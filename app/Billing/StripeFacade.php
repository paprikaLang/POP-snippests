<?php
/**
 * Created by PhpStorm.
 * User: paprika
 * Date: 2018/11/1
 * Time: 1:14 AM
 */

namespace App\Billing;


use Illuminate\Support\Facades\Facade;

class StripeFacade extends Facade
{
    protected static function getFacadeAccessor()
    {
        return 'billing';
    }
}