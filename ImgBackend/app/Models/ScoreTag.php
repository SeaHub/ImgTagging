<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/28 0028
 * Time: 17:03
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class ScoreTag extends Model
{
    public $table = 'score_tag';


    protected $primaryKey = 's_id';


    public $timestamps = false;


    protected $fillable = [
        'userId','t_id','score'
    ];


    protected $hidden = [

    ];

    protected $guarded = '';
}