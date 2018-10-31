<?php

namespace App\Providers;

use App\Billing\Stripe;
use Illuminate\Support\ServiceProvider;

class BillingServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }

    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
//        $this->app->singleton('Billing',function (){
//            return new Stripe();
//        });
        app()->bind('billing',Stripe::class);
        class_alias(\App\Billing\StripeFacade::class, 'Billing');
    }
}
