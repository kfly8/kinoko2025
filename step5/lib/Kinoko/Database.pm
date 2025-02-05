use v5.40;
use utf8;
use experimental qw(class);

use Mojo::SQLite;

class Kinoko::Database {
    field $dsn :param = $ENV{DATABASE_DSN};
    field $sqlite;

    ADJUST {
        $sqlite = Mojo::SQLite->new($dsn);
        $sqlite->db->dbh->do('PRAGMA journal_mode = WAL');
        $sqlite->db->dbh->do(q{
            CREATE TABLE IF NOT EXISTS posts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                comment TEXT NOT NULL,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        });
        $sqlite->on(connection => sub($sqlite, $dbh) {
            $dbh->do('PRAGMA synchronous = NORMAL');
        });
    }

    method select_posts() {
        my $posts = $sqlite->db->query('SELECT id, name, comment, timestamp FROM posts ORDER BY id DESC')->hashes;
    }

    method create_post($post) {
        return unless $post->{comment};
        $sqlite->db->query('INSERT INTO posts (name, comment) VALUES (?,?)', $post->{name}, $post->{comment});
    }
}
