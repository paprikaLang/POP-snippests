<?php
//use App\Billing\Stripe;
use Illuminate\Support\Facades\Route;
use Facades\App\Services\Weibo;
use Illuminate\Support\Facades\Event;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

//Event::listen('eloquent.created: App\Task',function (){
//    dd('a task created');
//});

Route::get('/', function () {
    return view('welcome');
});

Route::get('/tasks', function () {
    return \App\Task::all()->pluck('body');
});
Route::post('/tasks', function() {
    $task = \App\Task::create(['body'=> request('body')]);
    event(new \App\Events\TaskCreated($task));
});

Route::get('/task', function() {
    \App\Task::forceCreate(['body'=> '9']);
});

Route::get('/order', function () {
    $order = App\Order::find(2);
    event(new \App\Events\OrderUpdated($order));
});

Route::get('/stripe', function () {
    dd(Billing::charge());
//    dd(app('Billing')->charge());
});

Route::get('/weibo', function () {
    Weibo::publish('paprikaLang');//Non-static method App\Services\Weibo::publish() should not be called statically
});