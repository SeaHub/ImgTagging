<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/15 0015
 * Time: 14:54
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class StatisticsTag extends Model
{
    public $table = 'statistics_tag';


    protected $primaryKey = 'st_id';


    public $timestamps = false;


    protected $fillable = [
        'i_id','t_id','num'
    ];


    protected $hidden = [

    ];

    protected $guarded = '';

}