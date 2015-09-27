#!/usr/bin/env perl
use utf8;
use Mojolicious::Lite;
use lib '/Users/watanabe-yoichi/perl5/lib/perl5/';

use DBIx::Connector;
use Encode 'encode';

# DB接続の作成
my $dsn = 'dbi:SQLite:dbname=aaa.db';
my $conn = DBIx::Connector->new(
  $dsn, # データソース名
  undef, # ユーザー名
  undef, # パスワード
  # DBIのオプション
  {
    RaiseError     => 1,
    PrintError     => 0,
    AutoCommit     => 1,
    sqlite_unicode => 1, # 内部文字列を自動的にUTF-8バイト文字列に変換
  }
);

# データベースハンドルの取得
my $dbh  = $conn->dbh;

# テーブルの作成
my $create_table_sql = <<"EOS";
create table book (
  id primary key,
  title not null default '',
  author not null default ''
);
EOS
$dbh->do($create_table_sql);

# insert文
my $sth = $dbh->prepare('insert into book (id, title, author) values (?, ?, ?)');
$sth->execute('00000001', 'Perl', 'kimoto');

# update文
$sth = $dbh->prepare('update book set title = ? where author = ?');
$sth->execute('Ruby', 'taro');

# delete文
$sth = $dbh->prepare('delete from book where id = ?');
$sth->execute('00000001');

# insert文
$sth = $dbh->prepare('insert into book (id, title, author) values(?, ?, ?)');
$sth->execute('00000001', 'Perl Tutorial', '木本');
$sth->execute('00000002', 'Perl advantage', '健');
$sth->execute('00000003', 'Ruby Tutorial', '洋介');

# select文
my $sth = $dbh->prepare('select * from book where title like ?');
$sth->execute('%Perl%');

# フェッチ
while (my $row =  $sth->fetchrow_hashref) {
  my $id = $row->{id};
  my $title = $row->{title};
  my $author = $row->{author};

  my $line = "id: $id, title: $title, author: $author\n";

  # Windowsの場合はcp932で、それ以外のOSはUTF-8で出力
  my $enc = $^O eq 'MSWin32' ? 'cp932' : 'UTF-8';
  print encode($enc, $line);
}

