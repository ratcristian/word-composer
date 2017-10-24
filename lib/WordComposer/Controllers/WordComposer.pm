package WordComposer::Controllers::WordComposer;

use Mojo::Base 'Mojolicious::Controller';

use List::MoreUtils qw/ uniq /;
use Math::Combinatorics;

sub compose {
	my $self = shift();

  my $char_string = $self->param( 'chars' );
  my $slots = $self->param( 'slots' );

  my @chars = split( //, $char_string );
  my $size = scalar( @chars );

  if ( $slots > $size ) {
    return $self->render(
  			status => 400,
  			json => {
  				message => "Number of slots you provided is larger than number of characters!"
        }
    );
  }

  my $combinat = Math::Combinatorics->new( count => $slots, data => [ @chars ] );
  my @result = qw//;
  while( my @combo = $combinat->next_combination() ){
    my $sorted = uc( join( "", sort( @combo ) ) );

    push( @result, @{ $self->word_data()->{ $sorted } } )
      if( $self->word_data()->{ $sorted } );
  }
  use Data::Dumper;
  warn Dumper(@result);
  return $self->render( json => \@result );
}

1;
