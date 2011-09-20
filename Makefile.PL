use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'SourceView',
    AUTHOR        => 'Fuji, Goro <gfuji@cpan.org>',
    VERSION_FROM  => 'lib/SourceView.pm',
    PREREQ_PM     => {
        'Amon2'                           => '2.50',
        'Text::Xslate'                    => '1.1005',
        'Text::Xslate::Bridge::TT2Like'   => '0.00008',
        'Plack::Middleware::ReverseProxy' => '0.09',
        'Plack::Middleware::Log::Minimal' => '0.06',
        'Minimal'                         => '0.09',
        'HTML::FillInForm::Lite'          => '1.09',
        'Time::Piece'                     => '1.20',
        'Text::VimColor'                  => '0.13',
        'Furl'                            => '0.38',
        'Test::WWW::Mechanize'            => '0.35',
        'Cache::LRU'                      => '0.03',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
);
