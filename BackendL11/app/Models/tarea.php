<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class tarea extends Model
{
    use HasFactory;
    //Definimos el nombre de la tabla
    protected $table = "tarea";

    //Definimos el nombre de los campos.
    protected $fillable = [
        'Titulo',
        'Descripcion',
        'FechaEntrega',
        'Estado',
    ];
}