use v5.42;
use utf8;
use experimental qw(class);

class Kinoko::Database {
    field $dsn :param = $ENV{DATABASE_DSN};
    field $sqlite;

    method db() {
        $sqlite //= $self->&build_sqlite();
        $sqlite->db;
    }

    method select_posts() {
        my $posts = $self->db->query('SELECT id, name, comment, timestamp FROM posts ORDER BY id DESC')->hashes;
    }

    method create_post($post) {
        return unless $post->{comment};
        $self->db->query('INSERT INTO posts (name, comment) VALUES (?,?)', $post->{name}, $post->{comment});
    }

    # perl5.42 になったら、完全なprivateメソッドを実装できるようになりそう
    my method build_sqlite() {
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
