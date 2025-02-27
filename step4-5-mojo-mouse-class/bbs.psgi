use v5.40;
use utf8;
use lib 'lib';

use Mojolicious::Lite;
use Kinoko::Database;

helper db => sub { state $db = Kinoko::Database->new(dsn => $ENV{DATABASE_DSN}); };

get '/' => sub ($c) {
    my $posts = $c->db->select_posts();
    $c->stash(posts => $posts);
    $c->render(template => 'bbs/index');
};

post '/' => sub ($c) {
    my $post = {
        name => $c->param('name') || '名無し',
        comment => $c->param('comment') || '',
    };

    $c->db->create_post($post);

    $c->redirect_to('/');
};

app->start;
