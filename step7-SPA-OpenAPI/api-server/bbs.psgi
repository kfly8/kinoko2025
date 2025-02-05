use v5.40;
use utf8;
use lib 'lib';

use Mojolicious::Lite;
use Kinoko::Database;

helper db => sub { state $db = Kinoko::Database->new(); };

get '/api/post' => sub ($c) {
    my $posts = $c->db->select_posts();
    $c->render(json => $posts);
};

post '/api/post' => sub ($c) {
    my $data = $c->req->json;

    my $post = {
        name => $data->{name} || '名無し',
        comment => $data->{comment} || '',
    };

    my $id = $c->db->create_post($post);
    my $new_post = $c->db->select_post_by_id($id);

    $c->render(json => $new_post);
};

app->start;
