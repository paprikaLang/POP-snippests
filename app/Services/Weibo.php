<?php
/**
 * Created by PhpStorm.
 * User: paprika
 * Date: 2018/11/3
 * Time: 4:09 PM
 */

namespace App\Services;


class Weibo
{
    protected $http;
    public function __construct(Http $http)
    {
        $this->http = $http;
    }

    public function publish($status){
        $this->http->post($status);
    }
}