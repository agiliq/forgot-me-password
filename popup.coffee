genpwdapp={}


$(document).ready ->
    master_pwd=$("#master_pwd")
    if "genpwdapp_master_pwd" of localStorage
        master_pwd.val localStorage.genpwdapp_master_pwd
        master_pwd.attr "readonly","readonly"

    chrome.tabs.query {'active':true} , (tab) ->
        a = document.createElement('a')
        a.href = tab[0].url
        genpwdapp.domain = a.host.replace "www." , ""
        $("#domain").val genpwdapp.domain


#events 


    $("#btn_gen").bind 'click', ->

        if(master_pwd.val().length>0)
            localStorage.genpwdapp_master_pwd = master_pwd.val()
            hash=String(CryptoJS.MD5($("#master_pwd").val()+genpwdapp.domain))
            $("#gen_pwd").val hash.substr(0,8)
            master_pwd.attr "readonly","readonly"
    
        else
            $("#btn_gen").attr "disabled","disabled"
            $(".error").html "Please enter master password ! <br>"
            $(".error").show()
            master_pwd.removeAttr "readonly"
            master_pwd.focus()
            


# end of btn_gen bind


    $("#master_pwd").bind 'keyup', ->

        $("#btn_gen").removeAttr("disabled")
        $(".error").hide()

#end of master_pwd bind

    $("#btn_newmaster").bind 'click', ->

        r = confirm("Do you really want to set a new master password ? It will delete the old master password !")
        if r is true
            $("#master_pwd").val("")
            $("#master_pwd").removeAttr("readonly")
            $("#master_pwd").focus()
            localStorage.removeItem("genpwdapp_master_pwd")
    

# end of btn_newmaster bind
#end of document.ready



