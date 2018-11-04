<?php

namespace App;

use App\Events\PostWasPublished;
use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    protected $fillable = ['body'];

    protected $dispatchesEvents = [
        'created' => PostWasPublished::class
    ];
}
