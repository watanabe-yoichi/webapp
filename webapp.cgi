#!/usr/bin/env perl
use utf8;
use Mojolicious::Lite;
use lib '/Users/watanabe-yoichi/perl5/lib/perl5/';
use DBIx::Connector;

# DB接続の作成
my $dsn = 'dbi:SQLite:dbname=test.db';
my $conn = DBIx::Connector->new(
  $dsn, # データソース名
  undef, # ユーザー名
  undef, # パスワード
  # DBIのオプション
  {
    RaiseError => 1,
    PrintError => 0,
    AutoCommit => 1
  }
);
app->plugin('Config');

get '/' => sub {
  my $self = shift;

  my $app = $self->app;
  my $message = app->config('hoge');
  $app->log->info($message);

  my $message_new = $message.' : gagaga';
  $app->config(hoge2 => $message);

  $app->log->info($app->config('hoge2'));

  $self->render('index',
    old_hoge => $message,
    new_hoge => $message_new,
    name => 'kimoto',
    age  => 19,
    nums => [1, 2, 3],
  );
};

# リダイレクト
get '/some' => sub {
  my $self = shift;

  $self->redirect_to('/other');
};

get '/other' => sub {
  my $self = shift;

  $self->render(text => 'Other');
};

app->start;

