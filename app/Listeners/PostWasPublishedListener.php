<?php

namespace App\Listeners;

use App\Events\PostWasPublished;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class PostWasPublishedListener
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     *
     * @param  PostWasPublished  $event
     * @return void
     */
    public function handle(PostWasPublished $event)
    {
        dd($event->task->body);
    }
}
