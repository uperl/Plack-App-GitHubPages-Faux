package Plack::App::GitHubPages::Faux {

  use strict;
  use warnings;
  use 5.020;
  use parent 'Plack::App::File';
  use experimental qw( signatures postderef );
  use Path::Tiny qw( path );

  # ABSTRACT: PSGI app to test your GitHub Pages site

=head1 SYNOPSIS

 use Plack::App::GitHubPages::Faux;
 
 my $app = Plack::App::File->new( root => "/path/to/htdocs" )->to_app;

=head1 DESCRIPTION

This is a static file server PSGI application with some tweaks to operate similar
to a GitHub Pages website so that you can do some testing to see if your site
looks right before committing.  It is a pretty simple minded subclass of
L<Plack::App::File> with these feature additions:

=over 4

=item serve C<index.html> files for directory indexes

If a request is made against a directory with an C<index.html>
file, that index will be served as a response.

=item redirect to directory url with trailing C</>

This is important to get the right relative URLs in your indexes.

=item serve C<404.html> for not found

If you have a C<404.html> in your document root, this will be served
as the body for 404 Not Found responses.

=back

=cut

  sub should_handle ($self, $file)
  {
    return -f $file || -d $file;
  }

  sub serve_path ($self, $env, $path=undef, $fullpath=undef)
  {
    if(-d $path)
    {
      my $uri = $env->{PATH_INFO};
      my $index = path($path)->child('index.html')->stringify;
      return $self->return_404 unless -f $index;
      if($uri =~ m{/$})
      {
        $path = $index;
      }
      else
      {
        return
          [ 301,
            [
              'Location'       => "$uri/",
              'Content-Type'   => 'text/plain',
              'Content-Length' => 8,
            ],
            [ 'Redirect' ],
          ];
      }
    }

    return $self->SUPER::serve_path($env, $path, $fullpath);
  }

  sub return_404 ($self)
  {
    my $file = path($self->root)->child('404.html')->stringify;

    -f $file
      ? do {
        my $res = $self->serve_path(undef, $file);
        $res->[0] = '404';
        $res;
      }
      : $self->SUPER::return_404;
  }

}

1;

=head1 SEE ALSO

=over 4

=item L<Plack::App::File>

=back

=cut
