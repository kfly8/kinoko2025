package Kinoko::Database;
use strict;
use warnings;
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

    $sqlite->on(connection => sub {
        my ($sqlite, $dbh) = @_;
        $dbh->do('PRAGMA synchronous = NORMAL');
    });

    $sqlite;
}

sub select_posts {
    my $self = shift;
    my $posts = $self->db->query('SELECT id, name, comment, timestamp FROM posts ORDER BY id DESC')->hashes;
}

sub create_post {
    my ($self, $post) = @_;
    return unless $post->{comment};
    $self->db->query('INSERT INTO posts (name, comment) VALUES (?,?)', $post->{name}, $post->{comment});
}

1;
