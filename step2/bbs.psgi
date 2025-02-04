use strict;
use warnings;
use utf8;

use Plack::Request;
use Plack::Response;
use DBI;
use Template;

my $db_file = "bbs.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file","","", { RaiseError => 1, PrintError => 0 });
$dbh->do('PRAGMA journal_mode = WAL');

$dbh->do(q{
    CREATE TABLE IF NOT EXISTS posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        comment TEXT NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
});

my $template = Template->new({ INCLUDE_PATH => './templates' });

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $res = Plack::Response->new(200);

    if ($req->method eq 'POST') {
        my $name = $req->param('name') || '名無し';
        my $comment = $req->param('comment') || '';

        if ($comment ne '') {
            $dbh->do('INSERT INTO posts (name, comment) VALUES (?, ?)', undef, $name, $comment);
        }
        $res->redirect('/');
        return $res->finalize;
    }

    # 投稿データ取得
    my $sth = $dbh->prepare('SELECT id, name, comment, timestamp FROM posts ORDER BY id DESC');
    $sth->execute();
    my @posts;
    while (my $row = $sth->fetchrow_hashref) {
        push @posts, $row;
    }

    my $output;
    $template->process('bbs.tt', { posts => \@posts }, \$output) || die $template->error();

    $res->content_type('text/html; charset=UTF-8');
    $res->body($output);
    return $res->finalize;
};

$app;
