package SourceView::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;
use Furl;
use Encode qw(decode decode_utf8);
use Text::VimColor;
use File::Temp ();
use Log::Minimal;
use Text::Xslate::Util qw(mark_raw);
use Cache::LRU;

my $ua = Furl->new(
    agent => 'SourceView/1.0',
    headers => [ 'Accept-Encoding' => 'gzip', ],
);

my $cache = Cache::LRU->new(
    size => 100,
);

sub _get {
    my($uri) = @_;
    my $res = $cache->get($uri);
    if(!$res) {
        debugf 'get: %s', $uri;
        $res = eval { $ua->get($uri) };
        $cache->set($uri => $res);
    }
    return $res;
}

any '/' => sub {
    my($c) = @_;
    $c->render('index.tx');
};

any '/v/*', => sub {
    my($c, $r) =  @_;
    my($uri) = @{ $r->{splat} };

    my $res = _get($uri);
    if(!$res or !$res->is_success) {
        return $c->res_404;
    }
    my $content = $res->content;

    my($ext) = $uri =~ m{ (\. [^\/\.]+) \z}xms;

    my $file = File::Temp->new( SUFFIX => $ext );
    $file->print( $content );
    $file->close();

    my $sc = Text::VimColor->new(
        file => $file->filename,
    );
    my $n = 0;
    my $html = join "\n", map {
        $n++;
        qq[<span id="$n">$_</span>];
    } split /\n/, $sc->html();


    my $lines = ($content =~ tr/\n/\n/);
    $c->render('sourceview.tx', {
            uri    => $uri,
            lines  => $lines,
            source => mark_raw($html),
    } );
};

1;
