$(function(){

    $('.modal-close').html('');
    $('.modal-back').html('');
    $('.twister-user-remove').html('');
    $('.profile-card-main').attr('style', '');
    $('img[src$="img/tornado_avatar.png"]').attr("src","theme_nin/img/tornado_avatar.png");
    $('.mini-profile-actions span').html('');

    $.globalEval(postToElem.toString().replace(/postContext.append\(twister\.tmpl\.postRtBy/,
        'postContext.prependTo(postContext.parent()).append(twister.tmpl.postRtBy'));


    $( '.userMenu-home.current a' ).on( 'click', function() {
        $('html, body').animate({scrollTop:0},300);
        return false
    });

    $( ".promoted-posts-only").click(function() {
    // modify the way promoted posts are shown
        //active promoted posts tab
        $(this).children('.promoted-posts').addClass(promotedPostsOnly ? "active" : "disabled");
        $(this).children('.normal-posts').addClass(promotedPostsOnly ? "disabled" : "active");
        $('#postboard-top').removeClass(promotedPostsOnly ? "show" : "hide");
        //active normal posts
        $(this).children('.promoted-posts').removeClass(promotedPostsOnly ? "disabled" : "active");
        $(this).children('.normal-posts').removeClass(promotedPostsOnly ? "active" : "disabled");
        $('#postboard-top').addClass(promotedPostsOnly ? "hide" : "show");
    });

    $(window).scroll((function(){
        if ($(document).scrollTop() >= 250) {
            if (this.css('display') === 'none')
                this.slideDown(300);
        } else if (this.css('display') === 'block')
            this.slideUp(150);
    }).bind($('.left .post-area-new')));


    $('#search-profile-template .follow')
        .html('')
        .attr('title', polyglot.t('Follow'))
        .on('eventToggleFollow', function() {
            $(this).text('').attr('title', polyglot.t('Follow'));
        })
        .on('eventToggleUnfollow', function() {
            $(this).text('').attr('title', polyglot.t('Unfollow'));
        })
    ;

    if (/\/options.html$/i.test(document.location))
        $(document).ready(localizeLabels);
});

function localizeLabels() {
    $("label[for=tab_language]").text(polyglot.t("Language"));
    $("label[for=t-2]").text(polyglot.t("Theme"));
    $("label[for=t-3]").text(polyglot.t("Notifications"));
    $("label[for=t-4]").text(polyglot.t("Keys"));
    $("label[for=t-5]").text(polyglot.t("Appearance"));
    $("label[for=t-6]").text(polyglot.t("Users"));
}

