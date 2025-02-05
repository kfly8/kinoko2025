#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

# データファイル
my $data_file = "bbs_data.txt";

# CGIオブジェクトの作成
my $cgi = CGI->new;

# ユーザーが投稿したデータを取得
my $name    = $cgi->param('name') || "名無し";
my $comment = $cgi->param('comment') || "";

# 投稿があればデータを保存
if ($comment) {
    open(my $fh, ">>", $data_file) or die "データファイルに書き込めません: $!";
    print $fh "$name\t$comment\n";
    close($fh);
}

# HTMLヘッダー
print $cgi->header(-charset => "UTF-8");
print <<'HTML';
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>きのこBBS</title>
</head>
<body>
    <h1>きのこBBS</h1>
    <form method="post">
        名前: <input type="text" name="name"><br>
        コメント: <textarea name="comment" rows="4" cols="40"></textarea><br>
        <input type="submit" value="投稿">
    </form>
    <hr>
HTML

# 保存された投稿データを表示
if (-e $data_file) {
    open(my $fh, "<", $data_file) or die "データファイルを開けません: $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($saved_name, $saved_comment) = split(/\t/, $line);
        print "<p><strong>$saved_name</strong>: $saved_comment</p>\n";
    }
    close($fh);
}

print <<'HTML';
</body>
</html>
HTML
