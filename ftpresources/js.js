$(document).ready(function () {


    let checkIframeInterval = setInterval(checkIframeContent, 500);

    function checkIframeContent() {
        let iframeDoc = $('#evsframe').contents();
        let iframeContent = iframeDoc.find('article');
        if (iframeContent.length > 0) {
            let pathname = window.location.pathname;
            let tdElements = $('td.indexcolname');
            tdElements.each(function (index) {
                let anchorTag = $(this).find('a');
                let currentHref = anchorTag.attr('href');
                if (index) {
                    anchorTag.attr('href', window.location.pathname + currentHref);
                }
                anchorTag.attr('target', '_top');
        
            });            
            clearInterval(checkIframeInterval); // Stop checking
            console.log('Found .content div in iframe');
            loadIframeContent();
        } else {
            console.log('.content div not found in iframe');
        }
    }

    function loadIframeContent() {
        let iframeDoc = $('#evsframe').contents();
        let iframeContent = iframeDoc.find('article');
        let hrefs = iframeDoc.find('a');

        hrefs.each(function (index, e) {
            $(e).attr('target', '_top');
        });
        if (iframeContent.length > 0) {

            console.log('Found .content div in iframe');
            const listing = $('#indexlist').clone();
            $('#indexlist').remove();
            iframeContent.empty();
            iframeContent.append(listing);
        } else {
            console.log('.content div not found in iframe');
        }
    }
});
