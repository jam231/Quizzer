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
//= require_tree .

$(document).ready(function() {
    $("button[data-dismiss='alert']").click(function() {
        $(this).parent().remove();
    });
    registerOnUserClick();
    registerOnCurrentOwnerClick();
});


//= require jquery
function applyNewOwner(UserId, UserName, UserRank) {
    $("#new-owner-id").val(UserId);
    $("#new-owner-name").val(UserName);
    $("#new-owner-rank").val(UserRank);
    $("#new_owner_id").val(UserId);
}

function registerOnUserClick() {
    $("tr.user").click(function () {
        var newOwnerId = $(this).children("td.id").text(),
            newOwnerName = $(this).children("td.name").text(),
            newOwnerRank =  $(this).children("td.rank").text();
        applyNewOwner(newOwnerId, newOwnerName, newOwnerRank);
    });
}

function registerOnCurrentOwnerClick() {
    $("#current-owner").click(function () {
        var newOwnerId = $("#current-owner-id").val(),
            newOwnerName = $("#current-owner-name").val(),
            newOwnerRank = $("#current-owner-rank").val();
        applyNewOwner(newOwnerId, newOwnerName, newOwnerRank);
    });
}
