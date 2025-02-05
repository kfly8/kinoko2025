use v5.40;
use Mojolicious::Lite;
use Mojo::SQLite;

helper sqlite => sub {
    state $sqlite = do {
        my $sqlite = Mojo::SQLite->new('sqlite:bbs.db');

        $sqlite->db->dbh->do('PRAGMA journal_mode = WAL');
        $sqlite->db->dbh->do(q{
            CREATE TABLE IF NOT EXISTS posts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                comment TEXT NOT NULL,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        });

        $sqlite->on(connection => sub ($sql, $dbh) {
            $dbh->do('PRAGMA synchronous = NORMAL');
        });

        $sqlite;
    };
};

get '/' => sub ($c) {
    my $posts = $c->sqlite->db->query('SELECT id,name,comment,timestamp FROM posts ORDER BY id DESC')->hashes;
    $c->stash(posts => $posts);
    $c->render(template => 'bbs/index');
};

post '/' => sub ($c) {
    my $name = $c->param('name') || '名無し';
    my $comment = $c->param('comment') || '';

    if ($comment ne '') {
        $c->sqlite->db->query('INSERT INTO posts (name,comment) VALUES (?,?)', $name, $comment);
    }
    $c->redirect_to('/');
};

app->start;
