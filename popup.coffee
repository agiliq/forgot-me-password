genpwdapp={}


$(document).ready ->
    till=0    
    tldlist = []  
    foundlist = []
    
    
    foundlist.sort (a, b) ->
        a.length < b.length
    
    afterGetListCall = ->
        d = genpwdapp.domain
        total=0
        
        for i of d
            break if ""+i==""+till
            total++ if d[i]=="."
        
        j=0
    
        while j<total
            ind = d.indexOf(".")
            d=d.substr(ind+1,d.length)
            
            j++
   
        genpwdapp.domain = d
        $("#domain").val genpwdapp.domain
        
    getList = ->
    
        
        $.ajax(
            url: "http://mxr.mozilla.org/mozilla-central/source/netwerk/dns/effective_tld_names.dat?raw=1",
            beforeSend: () ->
                $("#domain").val "Loading......."
        ).done (data) ->
            
            
            
            i=0
            startindex = 0
            endindex=0
            temp = data.substr(0,data.indexOf("\n"))
            tldlist = []
            reg = /^[a-zA-Z.]+$/
            if temp.match(reg)
                tldlist[i]=temp
                i++
            while endindex!=-1             
                startindex = data.indexOf("\n",startindex)+1
                endindex = data.indexOf("\n",startindex) 
                l=data.substr(startindex,endindex-startindex)
                reg = /^[a-zA-Z.]+$/
                if l.match(reg)
                    tldlist[i]=l
                    i++
            fl = 0
            foundlist = []
            d = genpwdapp.domain
            for val in tldlist
                if (d+" ").indexOf("."+(val+" ")) > -1    
                    foundlist[fl] = val 
                    fl++

            if foundlist.length > 1
                foundlist.sort()
                for val in foundlist
                    if (d+" ").indexOf("."+(val+" ")) > -1
                        till = d.indexOf("."+val)
                        break
                    
                           
            else if foundlist.length == 0
                till = 0
            else
                till = d.indexOf("."+foundlist[0])
                                                           
                   
            afterGetListCall()
            
            

    
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
        arr = [".com" , ".co.in" , ".co.uk" ]  # add here some popular top level domains so that this script doesnt search the entire list all the time , it searches only when not found in the above list . 
        #but make sure that u dont add something that is a substring of another tld . 
        # for example , .in is a substring of .co.in , so if u add ".in" here before adding ".co.in" , output domain name will not be correct . Output may be wrong even if u add ".in" because ".co.in" is available in the main list , so when domain is google.co.in , it gives wrong output as it thinks that ".in" is the correct match . 
        # if you are in doubt about any tld, just dont enter it , the script will take care of it correctly. 
       
        
        till = -1
        for val in arr
            if d.indexOf(val) > -1
                till = d.indexOf val
        
        genpwdapp.domain = d
        
        if till==-1
            getList()
        else
            afterGetListCall()    
            
            
                    
    
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
            
            if master_pwd.attr "readonly"
                master_pwd.removeAttr "readonly"
            master_pwd.val("")
            master_pwd.focus()
            localStorage.removeItem("genpwdapp_master_pwd")

# end of btn_newmaster bind
#end of document.ready



