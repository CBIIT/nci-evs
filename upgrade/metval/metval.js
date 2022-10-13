//var results = 'Hard code results here for testing';

function getSecret(results) {
    var secret = "";

    var doc = new DOMParser().parseFromString(results, "text/html");
    // Get contents of the first H1 for the secret 
    var secret = doc.getElementsByTagName("h1")[0].innerHTML ;
    //console.log("secret: "+secret);

    return secret;
}

function getDecodedUrl(results) {
  //Use this code to create a new encryptedUrl if the secret changes.  The secret is hidden in a successful ajax call to rest service. (See code below)
  //var url = '/path/to/hidden/file';
  //var encrypted = CryptoJS.AES.encrypt(url, getSecret(results));
  //
  //console.log(decrypted.toString(CryptoJS.enc.Utf8));

  console.log("Metval Load");
      //console.log(getSecret(results));

      var encryptedUrl  = "U2FsdGVkX1+WMXTJFhasqh7eOjTQSkuTRAgiXeEGCWjLSAUmGaKxyfFQDyopkZV8VPegMSKJ8hnRpcX7cREPi16qHdaRvg2LcVqdQQ/45uA";
      var decrypted = CryptoJS.AES.decrypt(encryptedUrl, getSecret(results));
      var hiddenUrl = decrypted.toString(CryptoJS.enc.Utf8);
      //console.log(hiddenUrl);
      
      return hiddenUrl;
}

(function( $ ) {
    $("#EnterButton").click(function (e){
        $("#popup").show();
    });
    $("#close").click(function (e){
        $("#popup").hide();
    });
    $(document).ready(function() {

		  var metathesaurusFile = null;
		  /*
			$(document).on('click','.button',function(e) {
				//handler code here
        //console.log("Click on Overlay");

        //$("#block-nci-barrio-content").append('<div class="overlay"></div>');

			});
			*/
			
            $("#loginSubmit").click(function(e) {
            //alert($("input[name=apikey]").val());
			$.ajax({
                url: 'https://utslogin.nlm.nih.gov/cas/v1/api-key',
                type: 'post',
                data: "apikey="+$("input[name=apikey]").val(),
                error: function(xhr, statusText, err){
                    alert("UMLS Login unsuccessful");
                },
                success : function (result)	{
                        $('#download_meta').removeClass('disabled')
                    alert("UMLS Login successful.  Click on the Metathesaurus.RRF.zip file to download.");
                    metathesaurusFile = getDecodedUrl(result);
                    //console.log('metathesaurusFile = ' +metathesaurusFile);
                }
			});
			});

            $('#download_meta').click(function(e){
				e.preventDefault();
				  if ($(this).hasClass('disabled')) {
					  return false;
				  } else{
				    //console.log('Reroute to '+metathesaurusFile)
				    //alert("reroute to : "+metathesaurusFile);
					  document.location.href = metathesaurusFile;
                      //document.open("https://"+document.location+"/"+metathesaurusFile, "_blank");

				  }
			});
			
    }); // on document ready
})( jQuery );		