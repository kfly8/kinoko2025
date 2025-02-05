package Kinoko::Database;
use v5.40;
use utf8;

use parent 'Mojo::SQLite';

sub new {
    my $class = shift;

    my $sqlite = $class->SUPER::new(@_);

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

sub select_posts($self) {
    my $posts = $self->db->query('SELECT id, name, comment, timestamp FROM posts ORDER BY id DESC')->hashes;
}

sub create_post($self, $post) {
    return unless $post->{comment};
    $self->db->query('INSERT INTO posts (name, comment) VALUES (?,?)', $post->{name}, $post->{comment});
}

1;
