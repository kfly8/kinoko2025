use v5.40;
use utf8;
use lib 'lib';

use Mojolicious::Lite;
use Kinoko::Database;

helper db => sub { state $db = Kinoko::Database->new(); };

get '/api/post' => sub ($c) {
    my $posts = $c->db->select_posts();
    $c->render(openapi => $posts);
}, 'getPosts';

post '/api/post' => sub ($c) {
    $c = $c->openapi->valid_input or return;

    my $data = $c->req->json;

    my $post = {
        name => $data->{name} || '名無し',
        comment => $data->{comment} || '',
    };

    my $id = $c->db->create_post($post);
    my $new_post = $c->db->select_post_by_id($id);

    $c->render(openapi => $new_post);
}, 'createPost';

plugin OpenAPI => { url => app->home->rel_file('./openapi.yaml') };
app->start;
