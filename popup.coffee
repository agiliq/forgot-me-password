genpwdapp={}


$(document).ready ->
    master_pwd=$("#master_pwd")
    if "genpwdapp_master_pwd" of localStorage
        master_pwd.val localStorage.genpwdapp_master_pwd
        master_pwd.attr "readonly","readonly"

    chrome.tabs.query {'active':true} , (tab) ->
          
        
        
        a=document.createElement('a')
        a.href=tab[0].url
        d=""
        if a.host.substr(0,4) == "www."
            d=a.host.replace "www.",""
        else
            d=a.host
        till = d.indexOf ".com"
        
        total=0
        for i of d
            break if i==till
            total++ if d[i]=="."
        
        j=1
        
        while j<total
            ind = d.indexOf(".")
            d=d.substr(ind+1,d.length)
            #alert d
            j++
   
        genpwdapp.domain = d
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



