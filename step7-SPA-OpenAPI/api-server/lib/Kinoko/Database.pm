use v5.40;
use utf8;
use experimental qw(class);

class Kinoko::Database {
    field $dsn :param = $ENV{DATABASE_DSN};
    field $sqlite;

    method db() {
        $sqlite //= $self->_build_sqlite();
        $sqlite->db;
    }

    method select_posts() {
        my $posts = $self->db->query('SELECT id, name, comment, timestamp FROM posts ORDER BY id DESC')->hashes;
    }

    method select_post_by_id($id) {
        my $post = $self->db->query('SELECT id, name, comment, timestamp FROM posts WHERE id = ?', $id)->hash;
    }

    method create_post($post) {
        return unless $post->{comment};
        my $id = $self->db->insert(posts => $post)->last_insert_id;
    }

    method _build_sqlite() {
        require Mojo::SQLite;

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

        $sqlite;
    }
}
