(function() {
  var genpwdapp;

  genpwdapp = {};

  $(document).ready(function() {
    var afterGetListCall, foundlist, getList, master_pwd, till, tldlist;
    till = 0;
    tldlist = [];
    foundlist = [];
    foundlist.sort(function(a, b) {
      return a.length < b.length;
    });
    afterGetListCall = function() {
      var d, i, ind, j, total;
      d = genpwdapp.domain;
      total = 0;
      for (i in d) {
        if ("" + i === "" + till) break;
        if (d[i] === ".") total++;
      }
      j = 0;
      while (j < total) {
        ind = d.indexOf(".");
        d = d.substr(ind + 1, d.length);
        j++;
      }
      genpwdapp.domain = d;
      return $("#domain").val(genpwdapp.domain);
    };
    getList = function() {
      return $.ajax({
        url: "effective_tld_names.dat",
        beforeSend: function() {
          return $("#domain").val("Loading.......");
        }
      }).done(function(data) {
        var d, endindex, fl, i, l, reg, startindex, temp, val, _i, _j, _len, _len2;
        i = 0;
        startindex = 0;
        endindex = 0;
        temp = data.substr(0, data.indexOf("\n"));
        tldlist = [];
        reg = /^[a-zA-Z.]+$/;
        if (temp.match(reg)) {
          tldlist[i] = temp;
          i++;
        }
        while (endindex !== -1) {
          startindex = data.indexOf("\n", startindex) + 1;
          endindex = data.indexOf("\n", startindex);
          l = data.substr(startindex, endindex - startindex);
          reg = /^[a-zA-Z.]+$/;
          if (l.match(reg)) {
            tldlist[i] = l;
            i++;
          }
        }
        fl = 0;
        foundlist = [];
        d = genpwdapp.domain;
        for (_i = 0, _len = tldlist.length; _i < _len; _i++) {
          val = tldlist[_i];
          if ((d + " ").indexOf("." + (val + " ")) > -1) {
            foundlist[fl] = val;
            fl++;
          }
        }
        if (foundlist.length > 1) {
          foundlist.sort();
          for (_j = 0, _len2 = foundlist.length; _j < _len2; _j++) {
            val = foundlist[_j];
            if ((d + " ").indexOf("." + (val + " ")) > -1) {
              till = d.indexOf("." + val);
              break;
            }
          }
        } else if (foundlist.length === 0) {
          till = 0;
        } else {
          till = d.indexOf("." + foundlist[0]);
        }
        return afterGetListCall();
      });
    };
    master_pwd = $("#master_pwd");
    if ("genpwdapp_master_pwd" in localStorage) {
      master_pwd.val(localStorage.genpwdapp_master_pwd);
      master_pwd.attr("readonly", "readonly");
    }
    chrome.tabs.query({
      'active': true
    }, function(tab) {
      var a, arr, d, val, _i, _len;
      a = document.createElement('a');
      a.href = tab[0].url;
      d = "";
      if (a.host.substr(0, 4) === "www.") {
        d = a.host.replace("www.", "");
      } else {
        d = a.host;
      }
      arr = [".com", ".co.in", ".co.uk"];
      till = -1;
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        val = arr[_i];
        if (d.indexOf(val) > -1) till = d.indexOf(val);
      }
      genpwdapp.domain = d;
      if (till === -1) {
        return getList();
      } else {
        return afterGetListCall();
      }
    });
    $("#btn_gen").bind('click', function() {
      var hash;
      if (master_pwd.val().length > 0) {
        localStorage.genpwdapp_master_pwd = master_pwd.val();
        hash = String(CryptoJS.SHA256($("#master_pwd").val() + genpwdapp.domain));
        $("#gen_pwd").val(hash.substr(0, 8));
        return master_pwd.attr("readonly", "readonly");
      } else {
        $("#btn_gen").attr("disabled", "disabled");
        $(".error").html("Please enter master password ! <br>");
        $(".error").show();
        master_pwd.removeAttr("readonly");
        return master_pwd.focus();
      }
    });
    $("#master_pwd").bind('keyup', function() {
      $("#btn_gen").removeAttr("disabled");
      return $(".error").hide();
    });
    return $("#btn_newmaster").bind('click', function() {
      var r;
      r = confirm("Do you really want to set a new master password ? It will delete the old master password !");
      if (r === true) {
        if (master_pwd.attr("readonly")) master_pwd.removeAttr("readonly");
        master_pwd.val("");
        master_pwd.focus();
        return localStorage.removeItem("genpwdapp_master_pwd");
      }
    });
  });

}).call(this);
