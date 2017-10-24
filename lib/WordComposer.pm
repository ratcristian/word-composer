package WordComposer;

use Mojo::Base 'Mojolicious';

use File::ShareDir 'dist_dir';

our $VERSION = 1.6;

sub startup {
  my $app = shift();

  my $config = $app->plugin('Config', { file => sprintf( '%s/word_composer.conf', dist_dir('WordComposer') ) } );

  my $word_file = sprintf('%s/%s', dist_dir('WordComposer'), 'words.ro.no_special_characters');
  open( my $fh, '<:encoding(UTF-8)', $word_file )
    or die "Could not open file '$word_file' $!";

  my $data = {};
  while ( my $row = <$fh> ) {
    chomp $row;
    my @chars = split( //, $row );
    my $sorted = uc( join( "", sort( @chars ) ) );
    if ( $data->{ $sorted } ) {
      push( $data->{ $sorted }, $row );
    } else {
      $data->{ $sorted } = [ $row ]
    }
  }

  $app->helper(word_data => sub { return $data } );

  $app->routes()->get( '/api/:chars/:slots' )->to(
			controller => 'Controllers::WordComposer',
			action => 'compose',
		);
}

1;
