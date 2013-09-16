// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_self
//= require rails.validations
//= require_tree .

"use strict";

$(document).ready(function() {
    $("button[data-dismiss='alert']").click(function () {
        $(this).parent().remove();
    });
    registerOnRowClick(".user", ".id", ".name", ".rank", "#owner-id", "#owner-name", "#owner-rank", "#owner_id");
    registerOnRowClick(".group", ".id", ".name", ".owner-name", "#group-id", "#group-name", "#group-owner-name", "#group_id");
    registerOnCurrentOwnerClick();
});


function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}


function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().before(content.replace(regexp, new_id));
}

// Z gory przepraszam za takiego DRY jak ponizej, ale nie umiem js a zeby cos z tego wyszlo musialby troche nad tym przysiasc.

function applyNewOwner(arg1, arg2, arg3, dest1, dest2, dest3, dest4) {
    $(String(dest1)).val(arg1);
    $(String(dest2)).val(arg2);
    $(String(dest3)).val(arg3);
    $(String(dest4)).val(arg1);
}

function registerOnRowClick(rowName, firstName, secondName, thirdName, dest1, dest2, dest3, dest4) {
    $("tr" + rowName).click(function () {
        var arg1 = $(this).children("td" + firstName).text(),
            arg2 = $(this).children("td" + secondName).text(),
            arg3 =  $(this).children("td" + thirdName).text();
        applyNewOwner(arg1, arg2, arg3, dest1, dest2, dest3, dest4);
    });
}

function registerOnCurrentOwnerClick() {
    $("#current-owner").click(function () {
        var newOwnerId = $("#current-owner-id").val(),
            newOwnerName = $("#current-owner-name").val(),
            newOwnerRank = $("#current-owner-rank").val();
        applyNewOwner(newOwnerId, newOwnerName, newOwnerRank, "#owner-id", "#owner-name", "#owner-rank", "#owner_id");
    });
}