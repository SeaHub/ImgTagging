<?php

namespace App\Jobs;

use App\Models\UpdateRecord;

set_time_limit(0);

class ExampleJob extends Job
{
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        //
        while(1){
            $data=UpdateRecord::find(1);
            $data->is_exec=1;
            $data->createTime=time();
            $data->save();
            sleep(100);
            $data->is_exec=0;
            $data->createTime=time();
            $data->save();
            sleep(100);
        }
    }
}
