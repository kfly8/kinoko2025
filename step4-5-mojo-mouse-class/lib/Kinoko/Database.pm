package Kinoko::Database;
use Mouse;
use utf8;

has dsn    => ( is => 'ro', isa => 'Str', required => 1 );
has sqlite => ( is => 'ro', isa => 'Mojo::SQLite', lazy => 1, builder => '_build_sqlite' );

sub db {
    my $self = shift;
    $self->sqlite->db;
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

sub _build_sqlite {
    my $self = shift;

    my $sqlite = Mojo::SQLite->new($self->dsn);

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

__PACKAGE__->meta->make_immutable;
