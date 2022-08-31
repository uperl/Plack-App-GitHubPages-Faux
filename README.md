# Plack::App::GitHubPages::Faux

PSGI app to test your GitHub Pages site

# SYNOPSIS

```perl
use Plack::App::GitHubPages::Faux;

my $app = Plack::App::File->new( root => "/path/to/htdocs" )->to_app;
```

# DESCRIPTION

This is a static file server PSGI application with some tweaks to operate similar
to a GitHub Pages website so that you can do some testing to see if your site
looks right before committing.  It is a pretty simple minded subclass of
[Plack::App::File](https://metacpan.org/pod/Plack::App::File) with these feature additions:

- serve `index.html` files for directory indexes

    If a request is made against a directory with an `index.html`
    file, that index will be served as a response.

- redirect to directory url with trailing `/`

    This is important to get the right relative URLs in your indexes.

- serve `404.html` for not found

    If you have a `404.html` in your document root, this will be served
    as the body for 404 Not Found responses.

# SEE ALSO

- [Plack::App::File](https://metacpan.org/pod/Plack::App::File)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2018 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
