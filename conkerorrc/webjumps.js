

// web shortcuts
define_webjump("gsh",
               "http://goosh.org/#%s");
//               "Search Google Shell");
define_webjump("code",
               "https://code.whytheluckystiff.net/%s");
//               "Search Code at whytheluckystiff");
define_webjump("scholar",
               "http://scholar.google.co.in/scholar?hl=en&q=%s&btnG=Search&as_sdt=0%2C5&as_ylo=&as_vis=0");
//               "Search Code at whytheluckystiff");

// hints_default_object_classes["bookmarks"] = "links";
// define_webjump("g", "http://www.google.com/search?q=%s");
define_webjump("blackle",
               "http://www.google.com/cse?cx=013269018370076798483:gg7jrrhpsy4&cof=FORID:1&q=%s&sa=Search");
//              "Black Google");
define_webjump("oldg",
               "http://www.google.com/cse?cx=013269018370076798483:gg7jrrhpsy4&cof=FORID:1&q=%s&sa=Search");
//              "Google");
define_webjump("oldgoogle",
               "http://www.google.com/cse?cx=013269018370076798483:gg7jrrhpsy4&cof=FORID:1&q=%s&sa=Search");
//              "Google");
// define_webjump("search",
//                "http://www.google.com/cse?cx=013269018370076798483:gg7jrrhpsy4&cof=FORID:1&q=%s&sa=Search");
// //              "Search");
define_webjump("altsearch",
               'http://www.google.com/custom?hl=en&client=pub-6071644646659036&cof=FORID%3A13%3BAH%3Aleft%3BCX%3AGoogleBlackSearch%3BL%3Ahttp%3A%2F%2Fwww.google.com%2Fintl%2Fen%2Fimages%2Flogos%2Fcustom_search_logo_sm.gif%3BLH%3A30%3BLP%3A1%3BBGC%3A%23000000%3BT%3A%23ffffff%3BLC%3A%23008000%3BVLC%3A%2380ff00%3BGALT%3A%236f3c1b%3B&adkw=AELymgUvdaM8nU5n2tFte9c3we-XSQO146-wrqSqKoc_EeT1Af2TYUBtyH5YXsbKW9kVciGANHu1ixxAhIZRFHvWXqlj_4H-xAaU0CtJqzbtEjXILU5ETnL8n7T7u75eTDU4atKzzDJmZb3NGuvBBZN2cacxWvoKWBGc8hvpw12C8Slqnhf9usk0EP9ISXOXrZ_4a-TVA9xy&channel=1293889023&ie=ISO-8859-1&oe=ISO-8859-1&q=%s&btnG=Search&cx=partner-pub-6071644646659036%3A5wqdrnju8wy');
//              "Search");

define_webjump("search",
               "http://www.google.co.in/search?q=%s&hl=en&source=hp&aq=f&aqi=g10&aql=&oq=&gs_rfai=");
//              "Google");

// I'm Feeling Lucky.
define_webjump("clucky",
               "http://www.google.com/search?hl=en&biw=1364&bih=384&sclient=psy-ab&q=%s&oq=%s&aq=f&aqi=g4&aql=&gs_l=hp.9..0l4.0l0l5l1800l0l0l0l0l0l0l0l0ll0l0.frgbld.&pbx=1&btnI=1"
               // "http://www.google.com/search?btnI=I%27m+Feeling+Lucky&ie=UTF-8&oe=UTF-8&q=%s"
              )

// I'm Feeling Lucky.
define_webjump("lucky",
               "http://www.google.com/search?hl=en&&q=%s&btnI=1"
              )
               // "http://www.google.com/search?btnI=I%27m+Feeling+Lucky&ie=UTF-8&oe=UTF-8&q=%s"


define_webjump("blog",
               "http://blogsearch.google.com/blogsearch/cse?cx=013269018370076798483:gg7jrrhpsy4&cof=FORID:1&q=%s&sa=Search");
//              "Search");
// define_webjump("map",
//                "http://maps.google.co.in/maps?q=%s&um=1&ie=UTF-8&sa=N&hl=en&tab=wl");
//
define_webjump("tag",
               "http://del.icio.us/sh4r4d/%s");
//              "Your del.icio.us tag");
define_webjump("koders",
               "http://koders.com/default.aspx?s=%s&btn=&la=*&li=*");
//              "Koder code search");
define_webjump("cclass",
               "http://koders.com/default.aspx?s=cdef%3A%s&btn=&la=*&li=*");
//              "Koder C, C++ class function definition");
define_webjump("cinterface",
               "http://koders.com/default.aspx?s=idef%3A%s&btn=&la=*&li=*");
//              "Koder C C++ Interface");
define_webjump("cmethod",
               "http://koders.com/default.aspx?s=mdef%3A%s&btn=&la=*&li=*");
//              "Koder C Method");
define_webjump("cfile",
               "http://koders.com/default.aspx?s=file%3A%s&btn=&la=*&li=*");
//              "Koder C files");

// del.icio.us
add_delicious_webjumps("sh4r4d");
define_webjump("tag",
               "http://del.icio.us/sh4r4d/%s");
define_webjump("search/del",
               "http://delicious.com/search?p=%s");
// webjumps -sharad
define_webjump("blank",
               "about:blank");
//              "Blank page");
define_webjump("iwi",
               "http://iwiwdsmi.blogspot.com");
//              "IWI");
define_webjump("pandora",
               "http://www.pandora.com");
//               "Pendora");
define_webjump("reader",
               "http://www.google.com/reader");
//               "RSS Reader");

// from http://conkeror.org/Webjumps#GoogleTranslate


// 2. Contributed Webjumps

// Share your webjumps with the Conkeror community on this page. Please keep things somewhat organized.

// 2.1. Bookmarks

// This is a way to access bookmarks with completion via a
// webjump. This lets you visit bookmarks even when
// url_completion_use_bookmarks is false. In particular that might be
// so because you can't currently use both
// url_completion_use_bookmarks and url_completion_use_history.

define_webjump("bookmark",
               function(term) {return term;},
               $completer = history_completer($use_history = false,
                                              $use_bookmarks = true,
                                              $match_required = true),
               $description = "Visit a conkeror bookmark");

// 2.2. Computer Programs

// 2.2.1. ImageMagick

// // magick-options is a webjump for imagemagick command line options.
// //
// // magick-options caches its completions in a preference.  To clear the cache
// // and force magick-options to fetch the information anew, just do:
// //
// //   clear_pref('conkeror.webjump.magick-options.cache');
// //
// // last modified: November 25, 2009
// //

function magick_options_completer (input, cursor_position, conservative) {
    var completions;
    try {
        completions = get_pref('conkeror.webjump.magick-options.cache').split(' ');
    } catch (e) { }
    if (! completions) {
        try {
            var content = yield send_http_request(
                load_spec({uri: "http://www.imagemagick.org/script/command-line-options.php"}));
            completions = content.responseText
                .match(/([a-z]+)(?=\">-\1<\/a>)/g)
                .filter(remove_duplicates_filter());
            user_pref('conkeror.webjump.magick-options.cache', completions.join(' '));
        } catch (e) {
            completions = [];
        }
    }
    yield co_return(prefix_completer($completions = completions)
                    (input, cursor_position, conservative));
}

define_webjump("magick-options",
    "http://www.imagemagick.org/script/command-line-options.php#%s",
    $alternative = "http://www.imagemagick.org/script/command-line-options.php",
    $completer = magick_options_completer);

// 2.3. Entertainment

// 2.3.1. IMDb

define_webjump("imdb", "http://imdb.com/find?q=%s");

// 2.3.2. last.fm

lastfm_user = "your username here";
define_webjump("lastfm", "http://www.last.fm/user/" + lastfm_user);
define_webjump("lastfm-music", "http://www.last.fm/search?m=all&q=%s");
define_webjump("lastfm-event", "http://www.last.fm/events/search?search=1&q=%s");
define_webjump("lastfm-tag", "http://www.last.fm/search?m=tag&q=%s");
define_webjump("lastfm-user", "http://www.last.fm/users?m=search&type=un&q=%s");
define_webjump("lastfm-group", "http://www.last.fm/users/groups?s_bio=%s");
define_webjump("lastfm-label", "http://www.last.fm/search?m=label&q=%s");

// 2.3.3. Hulu

define_webjump("hulu", "http://www.hulu.com/search?query=%s");

// 2.3.4. Memory-Alpha

define_webjump("memory-alpha", "http://memory-alpha.org/en/wiki/Special:Search/?search=%s");

// 2.3.5. Roger Ebert's Movie Reviews

define_webjump(
    "ebert",
    function (term) {
        if (! term)
            return "http://rogerebert.suntimes.com/";
        return load_spec(
            { uri: "http://rogerebert.suntimes.com/apps/pbcs.dll/classifieds?category=search3",
              post_data: make_post_data([['Class','60'], ['Type', ''],
                                         ['FromDate', '19150101'], ['ToDate', '20091231'],
                                         ['Start', '1'], ['SortOrder', 'AltTitle'],
                                         ['Genre', ''], ['GenreMultiSearch', ''],
                                         ['RatingMultiSearch', ''],['MPAASearch', ''],
                                         ['SearchType', '1'], ['qrender', ''],
                                         ['Partial',''], ['q', term]])
    },
    $argument = 'optional')});

// 2.3.6. Rotten Tomatoes

define_webjump("rottentomatoes", "http://www.rottentomatoes.com/search/full_search.php?search=%s");

// 2.3.7. Youtube

define_webjump("youtube", "http://www.youtube.com/results?search_query=%s&search=Search");
define_webjump("youtube-user", "http://youtube.com/profile_videos?user=%s");

// 2.4. Finance

// 2.4.1. Google Finance

define_webjump("finance", "http://www.google.com/finance?q=%s");

// 2.5. Games

// 2.5.1. Anagrams

define_webjump("anagram", "http://wordsmith.org/anagram/anagram.cgi?anagram=%s&t=1000&a=n");

// 2.5.2. Kingdom of Loathing

define_webjump("kol", "http://kol.coldfront.net/thekolwiki/index.php/%s");

// 2.6. Index webjumps

// Index webjumps provide convenient access to a set of web pages that
// are indexed (referenced) from another page. Two kinds are provided;
// xpath webjumps and gitweb summary webjumps. Completions can be
// provided for the webjump by saving a copy of the index page to
// index_webjumps_directory, which can be set as follows.

// # Hey get it.
// require("index-webjump.js");
// index_webjumps_directory = get_home_directory();
// index_webjumps_directory.appendRelativePath(".conkerorrc/index-webjumps");

// For each defined index webjump the index page can be saved using M-x webjump-get-index.

// 2.6.1. Gitweb summary webjumps

// These webjumps help you visit repositories at a gitweb server:
// # Hey get it.
// define_gitweb_summary_webjump("gitweb-ko", "http://git.kernel.org");
// define_gitweb_summary_webjump("gitweb-cz", "http://repo.or.cz/w");

// You can now use the following webjumps:

// gitweb-cz conkeror
// gitweb-ko git/git

// To make completions available use M-x webjump-get-index and select gitweb-cz then, once the download is finished, completions will be available for that webjump. Sites with many repositories (such as the two given) can take many minutes to return the OPML data.

// When defining the webjump, a default repository at the gitweb server can be specified using the $default keyword. An $alternative may otherwise be given as usual. If neither are given then the alternative url for the webjump is defined to be the gitweb repository list page.

// 2.6.2. XPath webjumps

// An xpath webjump extracts the set of referenced web pages from an index page using an XPath expression. For these webjumps to work, the index must be downloaded using M-x webjump-get-index.

// Unfortunately, the xulrunner parser that is used is quite fussy and, in particular, is an xml parser. Many web pages fail to parse correctly. To correct this problem the downloaded index page is automatically cleaned up using index_xpath_webjump_tidy_command. The html tidy program should be installed for this to work.

// It can take a few attempts to figure out an appropriate XPath expression; index_webjump_try_xpath is provided to help with that process.

// # Hey get it.
// // Examples:

// define_xpath_webjump(
//     "gitdoc",
//     "http://www.kernel.org/pub/software/scm/git/docs/",
//     '//xhtml:dt/xhtml:a',
//     $description = "Git documentation");

// // The following examples require the html tidy program to be installed.

// define_xpath_webjump(
//     "conkerorwiki-page",
//     "http://conkeror.org/",
//     '//xhtml:li/xhtml:p/xhtml:a[starts-with(@href,"/")]',
//     $description = "Conkeror wiki pages linked from the front page");

// define_xpath_webjump(
//     "imagemagick-options",
//     "http://www.imagemagick.org/script/command-line-options.php",
//     '//xhtml:p[@class="navigation-index"]/xhtml:a',
//     $description = "Imagemagick command line options");

// 2.7. Language

// 2.7.1. Chinese

define_webjump("chinese", "http://www.mandarintools.com/cgi-bin/wordlook.pl?word=%s&searchtype=chinese&where=whole");
define_webjump("pinyin", "http://www.mandarintools.com/cgi-bin/wordlook.pl?word=%s&searchtype=pinyin&where=whole");
define_webjump("english", "http://www.mandarintools.com/cgi-bin/wordlook.pl?word=%s&searchtype=english&where=whole");

define_webjump("popupchinese",
    function (term) {
        return load_spec(
            { uri: "http://popupchinese.com/words/dictionary",
              post_data: make_post_data([['search', term]]) });
    },
    $alternative = "http://popupchinese.com/dictionary",
    $argument = 'optional');

define_webjump("nciku", "http://www.nciku.com/search/all/%s");

define_webjump("mdbg",
    "http://www.mdbg.net/chindict/chindict.php?page=worddictbasic&wdqb=%s&wdrst=0&wdeac=1",
    $alternative = "http://www.mdbg.net/chindict/chindict.php");

// 2.7.2. Esperanto

define_webjump("revo", "http://reta-vortaro.de/cgi-bin/sercxu.pl?cx=1&sercxata=%s");
define_webjump("sonja", "http://kisa.ca/vortaro/search.php?someaction=search&word=%s");

// 2.7.3. German

define_webjump("leo", "http://pda.leo.org/?lp=ende&lang=de&searchLoc=0&cmpType=relaxed&relink=on&sectHdr=off&spellToler=std&search=%s");

// 2.7.4. Japanese

define_webjump("e2j",
    function (term) {
        return load_spec(
            { uri: "http://www.freedict.com/onldict/onldict.php",
              post_data: make_post_data([['search', term], ['exact', 'true'], ['selected', '10'],
                                         ['from', 'English'], ['to', 'Japanese'],
                                         ['fname', 'eng2jap1'], ['back', 'jap.html']]) });
    },
    $alternative = "http://www.freedict.com/onldict/jap.html",
    $argument = 'optional');

define_webjump("j2e",
    function (term) {
        return load_spec(
            { uri: "http://www.freedict.com/onldict/onldict.php",
              post_data: make_post_data([['search', term], ['exact', 'true'], ['selected', '10'],
                                         ['from', 'Japanese'], ['to', 'English'],
                                         ['fname', 'eng2jap2'], ['back', 'jap.html']]) });
    },
    $alternative = "http://www.freedict.com/onldict/jap.html",
    $argument = 'optional');

// 2.7.5. Google Translate

define_webjump("trans", "http://translate.google.com/translate_t#auto|en|%s");

// This will autodetect the source language and translate into
// English. Replace en with your native language if necessary. This
// could fairly easily be improved to take source and dest languages
// as parameters and autocomplete on them but it works well enough for
// now.
// 2.7.6. Urban Dictionary

define_webjump("urban", "http://www.urbandictionary.com/define.php?term=%s");

// 2.7.8. Acronyms finders
define_webjump("acronyms/wiktionary", "http://en.wiktionary.org/wiki/%s");
define_webjump("acronyms/netlingo", "http://www.netlingo.com/word/%s.php");
define_webjump("acronyms/slang", "http://www.internetslang.com/%s-meaning-definition.asp");
define_webjump("acronyms/abbreviations", "http://www.abbreviations.com/%s");
define_webjump("acronyms/acronyms", "http://acronyms.thefreedictionary.com/%s");
"acronyms/acronymsfinder", "http://www.acronymfinder.com/~/search/af.aspx?Acronym=%s&Find=find&string=exact"

// 2.8. Network Tools

// 2.8.1. Down for everyone or just me?

define_webjump("down?", function (url) {
    if (url) {
        return "http://downforeveryoneorjustme.com/" + url;
    } else {
        return "javascript:window.location.href='http://downforeveryoneorjustme.com/'+window.location.href;";
   }
}, $argument = "optional");

// 2.8.2. The Wayback Machine

define_webjump("wayback", function (url) {
    if (url) {
        return "http://web.archive.org/web/*/" + url;
    } else {
        return "javascript:window.location.href='http://web.archive.org/web/*/'+window.location.href;";
    }
}, $argument = "optional");

// 2.9. News

// 2.9.1. Google News

define_webjump("news", "http://news.google.com/news/search?q=%s");

// 2.10. Programming

// 2.10.1. Google Codesearch

define_webjump("codesearch", "http://www.google.com/codesearch?q=%s");

define_webjump("code/fossies", "http://fossies.org/search?q=%s&rd=%2Ffresh%2F&sd=0&ud=%2F&ap=no&ca=no&dp=0&si=0&sn=1&ml=30&dml=3");

// 2.10.2. Perl

define_webjump("perldoc", "http://perldoc.perl.org/search.html?q=%s");
define_webjump("cpan", "http://search.cpan.org/search?query=%s&mode=all");

// 2.10.3. Qt

define_webjump("qt", "http://doc.qtsoftware.com/4.5/%s.html");

// Not actually a search engine, but it's good enough to look up classes by name.

// 2.10.4. TeX

define_webjump("ctan-desc", "http://www.ctan.org/cgi-bin/search.py?"+
               "metadataSearch=%s&metadataSearchSubmit=Search");
define_webjump("ctan-pack", "http://www.ctan.org/cgi-bin/search.py?"+
               "tdsFilename=%s&tdsFilenameSearch=Search");
define_webjump("ctan-file", "http://www.ctan.org/cgi-bin/filenameSearch.py?"+
               "filename=%s&Search=Search");
define_webjump("ctan-doc", "http://www.ctan.org/cgi-bin/searchFullText.py?"+
               "fullTextSearch=%s&fullTextSearchSubmit=Search");

// 2.11. Reference

// 2.11.1. Wikipedia

// The Wikipedia webjumps are now included with Conkeror. Put the following in your .conkerorrc to use it:

// require("page-modes/wikipedia.js");
// wikipedia_webjumps_format = "wp-%s"; // controls the names of the webjumps.  default is "wikipedia-%s".
// define_wikipedia_webjumps("en", "de", "fr"); // For English, German and French.
// define_wikipedia_webjumps(); // To make use of ALL of the webjumps (200+).

// Some people like having to only type the language code to get to a
// Wikipedia, in that case you can just set the format to "%s". This
// means you can write only "en bruce springsteen" to get to the
// article about Bruce Springsteen on the English Wikipedia.

// 2.11.2. Wolfram Alpha

define_webjump("alpha", "http://www36.wolframalpha.com/input/?i=%s");

// 2.12. Search Engines

// 2.12.1. Cuil

define_webjump("cuil", "http://www.cuil.com/search?q=%s");

// 2.12.2. SoGou

define_webjump("sogou", "http://www.sogou.com/web?query=%s");

// 2.12.3. Scroogle

define_webjump("scroogle", "http://www.scroogle.org/cgi-bin/nbbw.cgi?Gw=%s");
define_webjump("scrooglessl", "https://ssl.scroogle.org/cgi-bin/nbbwssl.cgi?Gw=%s");

// 2.13. Shopping

define_webjump("netflix", "http://www.netflix.com/Search?v1=%s");
define_webjump("amazon", "http://www.amazon.com/exec/obidos/external-search/?field-keywords=%s&mode=blended");

// 2.14. Software

// 2.14.1. Debian package searches

// These are included (in a slightly modified version) by default in
// the Debian and Ubuntu packages starting with version 0.9.1-1:

define_webjump("deb", "http://packages.debian.org/search?keywords=%s&searchon=names&suite=unstable&section=all");
define_webjump("debfile", "http://packages.debian.org/search?searchon=contents&keywords=%s&mode=path&suite=unstable&arch=any");
define_webjump("debbugs", "http://bugs.debian.org/%s");
define_webjump("debpts", "http://packages.qa.debian.org/%s");

// Not yet included in the Debian and Ubuntu packages are the following Debian webjumps:

define_webjump("buildd", "https://buildd.debian.org/%s");
define_webjump("buildd-experimental", "http://experimental.ftbfs.de/%s");
define_webjump("buildd-ports", "http://buildd.debian-ports.org/build.php?pkg=%s");
define_webjump("debqa", "http://qa.debian.org/developer.php?login=%s");

// Adjust suite, arch etc to suit.

// 2.14.2. Ubuntu / Launchpad package searches

// These are included by default in the Debian and Ubuntu packages starting with version 0.9.1-1:

define_webjump("ubuntupkg", "http://packages.ubuntu.com/%s");
define_webjump("ubuntufile", "http://packages.ubuntu.com/search?searchon=contents&keywords=%s&mode=path&arch=any");
define_webjump("ubuntubugs", "http://launchpad.net/ubuntu/+source/%s");
define_webjump("launchpad", "https://launchpad.net/+search?field.text=%s");


define_webjump("soft/altvto", "http://alternativeto.net/SearchResult.aspx?search=%s");
define_webjump("soft/osalto", "http://www.osalt.com/search?q=%s");

// 2.14.3. Github search

define_webjump("github", "http://github.com/search?q=%s&type=Everything");

// 2.14.4. Ohloh project search

define_webjump("ohloh", "https://www.ohloh.net/p?query=%s");

// 2.14.5. Savannah project search

define_webjump("savannah", "https://savannah.gnu.org/search/?words=%s&type_of_search=soft");

// 2.15. Sports

// 2.15.1. Bicycling

define_webjump("sheldonbrown",
               "http://www.google.com/search?q=site:sheldonbrown.com %s",
               $alternative = "http://sheldonbrown.com/");

// 2.16. Travel

// 2.16.1. Wikitravel

define_webjump("wikitravel", "http://wikitravel.org/en/Special:Search/?search=%s");

// 2.17. Weather

// 2.17.1. Weather Underground

define_webjump("weather", "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=%s");

// {{ My Added
define_webjump("gtrans", function (url) {
    if (url) {
        // return "http://translate.google.com/#auto|en|" + url;
        return "http://translate.google.com/translate?js=y&prev=_t&hl=en&ie=UTF-8&layout=1&eotf=1&u=" + url + "&sl=auto&tl=en";
    } else {
        return "javascript:window.location.href='http://translate.google.com/translate?js=y&prev=_t&hl=en&ie=UTF-8&layout=1&eotf=1&u='+window.location.href+'&sl=auto&tl=en';";
    }
}, $argument = "optional");


define_webjump("mtime", "javascript:alert(document.lastModified)");

define_webjump("torrentz", "http://www.torrentz.com/search?f=%s");

define_webjump("pustak", "http://pustak.co.in/pustak/books/search?q=%s&type=genericSearch&page=1");

define_webjump("isbn-biblio-search", "http://www.biblio.com/search.php?keyisbn=%s");

define_webjump("isbn-books-by-isbn-search", "http://www.books-by-isbn.com/cgi-bin/isbn-lookup.pl?isbn=%s");

// define_webjump("anonweb", "http://www.surf-proxy.de/index.php?q=%s");

define_webjump("anonweb", function (url) {
    if (url) {
        return "http://www.surf-proxy.de/index.php?q=" + url;
    } else {
        return "javascript:window.location.href='http://www.surf-proxy.de/index.php?q='+window.location.href;";
   }
}, $argument = "optional");

//

// }}

// {{ One Time Mail
define_webjump("otmread/wh4f",
               function (user) {
        return load_spec(
            { uri: "http://www.wh4f.org/index.php?p=readmail",
              post_data: make_post_data([['login_username', user],
                                         ['login_password', 'kill'],
                                         ['autologin', '0'],
                                         ['login', ' Login ']
                                        ]) });
    },
    $alternative = "http://www.wh4f.org/index.php",
    $argument = 'optional');

define_webjump("otmregister/wh4f",
               function (user) {
        return load_spec(
            { uri: "http://www.wh4f.org/index.php?p=home",
              post_data: make_post_data([['register_username', user],
                                         ['register_password', 'kill'],
                                         ['register_expire', '8'],
                                         ['register', ' Register ']
                                        ]) });
    },
    $alternative = "http://www.wh4f.org/index.php",
    $argument = 'optional');

define_webjump("otmread/10min",
               "http://10minutemail.com/10MinuteMail/index.html");


define_webjump("otmread/mailinator-auto",
               "http://www.mailinator.com/");

define_webjump("otmread/mailinator-email",
               "http://www.mailinator.com/maildir.jsp?email=%s&x=0&y=0");
// }}



// check plugin work with rails3 or not.
define_webjump("work-with-rails3",
               "http://railsplugins.org/plugins/search?search=%s&commit=Search");

define_webjump("professional", // Professional Couriers
               "http://tpcindia.com/track.aspx?id=%s");

define_webjump("whois", // Professional Couriers
               "http://www.who.is/whois/%s/");

// {
define_webjump("finance-quote", // Stock quote
               "http://finance.yahoo.com/q?s=%s");
// }

define_webjump("emacswiki",
    "http://www.google.com/cse?cx=004774160799092323420%3A6-ff2s0o6yi"+
        "&q=%s&sa=Search&siteurl=emacswiki.org%2F",
    $alternative="http://www.emacswiki.org/");

define_webjump("lispdoc",
               "http://lispdoc.com/?q=%s&search=Basic+search");

define_webjump("lispdocfull",
               "http://lispdoc.com/?q=%s&search=Full+text+search");

// "http://www.google.com/custom?q=defstructbind&sa=Google+Search&client=pub-9189966831921234&forid=1&channel=7601138232&ie=UTF-8&oe=UTF-8&flav=0000&sig=BT4vXQm3jSJWiv_9&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23FFFFFF%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3A336699%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BFORID%3A1&hl=en"


// Get code snippets
define_webjump("snippets",
               "http://snippets.dzone.com/search/get_results?q=%s");
define_webjump("gsnippets",
               "http://www.google.co.in/search?q=%20site%3Asnippets.dzone.com%20%s%20&hl=en&source=hp&aq=f&aqi=g10&aql=&oq=&gs_rfai");
define_webjump("languages",
               "http://rosettacode.org/mw/index.php?title=Special%3ASearch&search=%s&go=Go");

// http://www.123people.com/s/firstname+lastname/world

// "http://search.businessweek.com/Search?q=%s&resultsperpage=20&searchterm=%s&sortby=relevance&u1=searchterm"

define_webjump("company",
               "http://search.businessweek.com/Search?searchTerm=%s&resultsPerPage=20");

define_webjump("stock-us",
               "http://investing.businessweek.com/research/stocks/snapshot/snapshot.asp?ticker=%s:US");

define_webjump("stock-india",
               "http://investing.businessweek.com/research/stocks/snapshot/snapshot.asp?ticker=%s:IN");

define_webjump("stock",
               "http://investing.businessweek.com/research/common/symbollookup/symbollookup.asp?textIn=%s");

define_webjump("trade",
               "https://us.etrade.com/e/t/home");

define_webjump("book/flipkart",
               "http://www.flipkart.com/search/a/books?query=%s&vertical=books&dd=0&autosuggest%5Bas%5D=off&autosuggest%5Bas-submittype%5D=default-search&autosuggest%5Bas-grouprank%5D=0&autosuggest%5Bas-overallrank%5D=0&Search=%C2%A0&_r=n_2yuAC4xgh0SZTuulvAtw--&_l=Tnndui8JdMVk7CZmDKIfXQ--&ref=7f487d10-54d7-493d-a35e-a1517d505577&selmitem=Books");

define_webjump("book/sapna",
               "http://sapnaonline.com/index.php?option=com_payment&view=search&filter=any&q=%s&search=Search");

define_webjump("book/shops",
               "http://www.biblio.com/search.php?author=&title=%skeyisbn=");
// "http://www.biblio.com/search.php?stage=1&title=art+of+assembly+language&pageper=20&strip_common=1&program=1005&order=priceasc")


// Electronics
define_webjump("electronics/element14",
               "http://in.element14.com/jsp/search/browse.jsp?N=0&Ntk=gensearch&Ntt=%s&Ntx=mode+matchallpartial&exposeLevel2Refinement=true&suggestions=false&ref=globalsearch");


// Notes
// http://mozdev.org/pipermail/conkeror/2009-September/001694.html
define_webjump("clip",
               "javascript:(function(){EN_CLIP_HOST='http://www.evernote.com';try{var%20x=document.createElement('SCRIPT');x.type='text/javascript';x.src=EN_CLIP_HOST+'/public/bookmarkClipper.js?'+(new%20Date().getTime()/100000);document.getElementsByTagName('head')[0].appendChild(x);}catch(e){location.href=EN_CLIP_HOST+'/clip.action?url='+encodeURIComponent(location.href)+'&title='+encodeURIComponent(document.title);}})();");



//{{ Stock
define_webjump("stock/income-statement",
               "http://finance.yahoo.com/q/is?s=%s");
//}} Stock

//{{ Rail
define_webjump(
    "train/pnr",
    function (term) {
        if (! term)
            return "http://indianrail.gov.in/pnr_Enq.html";
        return load_spec(
            { uri: "http://www.indianrail.gov.in/cgi_bin/inet_pnrstat_cgi.cgi",
              post_data: make_post_data([
                  ['lccp_pnrno1', term],
                  ['submit', 'Get Status']
              ])
    },
    $argument = 'optional')});

define_webjump(
    "train/schedule",
    function (term) {
        if (! term)
            return "http://www.indianrail.gov.in/train_Schedule.html";
        return load_spec(
            { uri: "http://www.indianrail.gov.in/cgi_bin/inet_trnnum_cgi.cgi",
              post_data: make_post_data([
                  ['lccp_trnname', term],
                  ['submit', 'Get Schedule']
              ])
    },
    $argument = 'optional')});


define_webjump(
    "train/inquery",
    function (term) {
        if (! term)
            return "http://www.trainenquiry.com/";
        return load_spec(
            { uri: "http://www.trainenquiry.com/SearchTrain.aspx",
              post_data: make_post_data([
                  ['keywords', term],
                  ['go-button', 'go']
              ])
    },
    $argument = 'optional')});


define_webjump(
    "train/indiarailinfo",
    function (term) {
        if (! term)
            return "http://indiarailinfo.com/";
        return load_spec(
            { uri: "http://indiarailinfo.com/",
              post_data: make_post_data([
                  ['keywords', term],
                  ['go-button', 'go']
              ])
    },
    $argument = 'optional')});


//}}


//{{ People
define_webjump(
    "people/123people",
    "http://www.123people.com/s/%s");

define_webjump(
    "people/spokeo",
    "http://www.spokeo.com/search?q=%s");

define_webjump(
    "people/zoominfo",
    function (term) {
        if (! term)
            return "http://www.zoominfo.com/";
        return load_spec(
            { uri: "http://www.zoominfo.com/",
              post_data: make_post_data([
                  ['personName', term],
                  ['submit', 'find']
              ])
    },
    $argument = 'optional')});

//}}


//{{ Law
// IPC
define_webjump(
    "law/ipc",
    "http://indiankanoon.org/search/?formInput=%s");
//}}


//{{ Reviews
define_webjump(
    "review/mouthshut",
    "http://www.mouthshut.com/search/prodsrch.aspx?data=%s&type=&p=0");

define_webjump(
    "review/phone/gsmarena",
    "http://www.gsmarena.com/results.php3?sQuickSearch=yes&sName=%s");

define_webjump(
    "review/phone/phonearena",
    "http://www.phonearena.com/search/term/%s");
//}}


//{{
define_webjump(
    "price/mysmartprice",
    "http://www.mysmartprice.com/msp/findprice.php?title=%s&isbn=-1");
//}}

//{{
define_webjump(
    "phone/ispyprice",
    "http://www.ispyprice.com/search/%s/");

define_webjump(
    "phone/smartprix",
    "http://www.smartprix.com/finder.php?q=%s");
//}}

//{{Phone Stuff
define_webjump(
    "dial",
    "http://www.justdial.com/index.php?city=%swhat=%s");
//}}

//{{ Search in site
// Search in site

define_webjump("sitesearch", function (term) {
    return "javascript:window.location.href='http://www.google.co.in/search?q=site:'+window.location.hostname+'%20"+encodeURIComponent(term)+"&hl=en&source=hp&aq=f&aqi=g10&aql=&oq=&gs_rfai='";
}, $argument = "optional");


define_webjump("sitesearch", function (term) {
    return "javascript:window.location.href='http://www.google.com/search?sitesearch='+window.location.hostname+'&as_q=" + encodeURIComponent(term) + "';";
}, $argument = "optional");

define_webjump("search/similarsites", function (url) {
    if (url) {
        return "http://www.similarsites.com/site/" + url;
    } else {
        return "javascript:window.location.href='http://www.similarsites.com/site/'+window.location.hostname;";
    }
}, $argument = "optional");

//}}



// homepage = "http://www.google.com";

// set default webjump
read_url_handler_list = [read_url_make_default_webjump_handler("google")];
// possibly valid URL
function possibly_valid_url (str) {
    return (/[\.\/:]/.test(str)) &&
        !(/\S\s+\S/.test(str)) &&
        !(/^\s*$/.test(str));
}

// page modes
require("page-modes/google-search-results.js"); // google search results
require("page-modes/wikipedia.js");     // wikipedia mode

// webjumps
define_webjump("gmail", "https://mail.google.com"); // gmail inbox
define_webjump("twitter", "http://twitter.com/#!/search/%s", $alternative = "https://twitter.com/");  // twitter
define_webjump("w3schools", "http://www.w3schools.com"); // w3schools site
define_webjump("w3search", "http://www.google.com/search?sitesearch=www.w3schools.com&as_q=%s"); // w3schools search
define_webjump("jquery", "http://docs.jquery.com/Special:Search?ns0=1&search=%s"); // jquery
define_webjump("archwiki", "https://wiki.archlinux.org/index.php?search=%s"); // arch wiki
define_webjump("stackoverflow", "http://stackoverflow.com/search?q=%s", $alternative = "http://stackoverflow.com/"); // stackoverflow
define_webjump("sor", "http://stackoverflow.com/search?q=[r]+%s", $alternative = "http://stackoverflow.com/questions/tagged/r"); // stackoverflow R section
define_webjump("stats", "http://stats.stackexchange.com/search?q=%s"); // stats
define_webjump("torrentz", "http://torrentz.eu/search?q=%s"); // torrentz
define_webjump("avaxsearch", "http://avaxsearch.com/avaxhome_search?q=%s&a=&c=&l=&sort_by=&commit=Search"); // avaxsearch
define_webjump("imdb", "http://www.imdb.com/find?s=all;q=%s"); // imdb
define_webjump("duckgo", "http://duckduckgo.com/?q=%s", $alternative = "http://duckduckgo.com"); // duckduckgo
define_webjump("blekko", "http://blekko.com/ws/%s", $alternative = "http://blekko.com/"); // blekko
define_webjump("youtube", "http://www.youtube.com/results?search_query=%s&aq=f", $alternative = "http://www.youtube.com"); // youtube
define_webjump("duckgossl", "https://duckduckgo.com/?q=%s"); // duckduckgo SSL
define_webjump("downforeveryoneorjustme", "http://www.downforeveryoneorjustme.com/%s"); // downforeveryoneorjustme
define_webjump("urbandictionary", "http://www.urbandictionary.com/define.php?term=%s"); // urban dictionary
define_webjump("rts", "http://rts.rs");             // RTS
define_webjump("facebook", "http://www.facebook.com");      // facebook homepage
define_webjump("mobile/trace/bharatiyamobile", "http://trace.bharatiyamobile.com/?numb=%s");
define_webjump("mobile/trace/store", "http://tracker.mobileringtonesstore.com/mobiletracker.php?no=%s");
define_webjump("mobile/trace/india", "http://indiatrace.com/trace-mobile-number-location/trace-mobile-number-location.php?N=%s");

//{{
define_webjump("search/auto", "http://lmgtfy.com/?q=%s");
define_webjump("search/clusty", "http://clusty.com/search?query=%s");
define_webjump("search/duckduckgo", "https://duckduckgo.com/?q=%s");
define_webjump(
    "search/ixquick",
    function (term) {
        if (! term)
            return "https://osnews.com";
        return load_spec(
            { uri: "https://us4.ixquick.com/do/search",
              post_data: make_post_data([
                  ['query', term],
                  ['abp', '-1'],
                  ['engine0', 'v1all'],
                  ['language', 'english'],
                  ['cmd', 'process_search'],
                  ['cat', 'web'],
                  ['submit', 'find']
              ])
    },
    $argument = 'optional')});

//}}

//{ Man Page
define_webjump("search/man", "http://man.cx/%s");
define_webjump("man", "http://man.cx/%s");
//}

// define_webjump("tinyurl/f0rk",
//                function(){
//                    var ali=prompt('Enter a custom alias:');
//                    if(ali) {
//                        location.href='http://f0rk.in/index.php?url='   escape(location.href)   '&alias=' ali;
//                    }
//                },
//               $argument = 'optional');



// javascript:void( location.href = 'http://f0rk.in/index.php?alias=&url=' escape(location.href))


//{IRC
define_webjump("irc/searchirc", "http://searchirc.com/irc-%s-1");
define_webjump("irc/netsplit", "http://irc.netsplit.de/channels/?chat=%s");
//}


//{{
define_webjump("src/kernel", "http://www.kneuro.net/cgi-bin/lxr/http/ident?i=%s");
// define_webjump("src/linux", "http://lxr.linux.no/linux+v2.6.12.1/+search");

define_webjump(
    "src/linux",
    function (term) {
        if (! term)
            return "http://lxr.linux.no/linux/+search";
        return load_spec(
            { uri: "http://lxr.linux.no/linux/+search",
              post_data: make_post_data([
                  ['search', term],
                  ['submit', 'Search']
              ])
            },
    $argument = 'optional')});


//}}



//{{ online marteking
define_webjump("buy/india-tradus", "http://www.tradus.com/search?query=%s&availability=true");
define_webjump("buy/india-ebay", "http://www.ebay.in/sch/i.html?_nkw=%s");
define_webjump("buy/flipkart",
               "http://www.flipkart.com/search/a/all?query=%s&vertical=all&dd=0&autosuggest%5Bas%5D=off&autosuggest%5Bas-submittype%5D=entered&autosuggest%5Bas-grouprank%5D=0&autosuggest%5Bas-overallrank%5D=0&Search=%C2%A0&_r=n_2yuAC4xgh0SZTuulvAtw--&_l=Tnndui8JdMVk7CZmDKIfXQ--&ref=86996893-c57b-498e-ad0d-3c6819910b56&selmitem=");

define_webjump("buy/jabong",
               "http://www.jabong.com/catalog/?q=%s&submit=&baseUrl=");

define_webjump("buy/yebhi",
               "http://www.yebhi.com/searchAll.aspx?q=%s");



//}}

//{{ online deal
define_webjump("deal/desidime", "http://www.desidime.com/topics/search?q=%s");
//}}


//{{ Good Feed
define_webjump("rss/reddit", "http://www.reddit.com/r/emacs/search?q=%s");
//}}
