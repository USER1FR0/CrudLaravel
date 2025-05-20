<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\TareaController;

Route::middleware('api')->prefix('v1/tarea')->group(function(){
    Route::get('/',[TareaController::class,'get']);
    Route::post('/',[TareaController::class,'create']);
    Route::get('/{Titulo}',[TareaController::class,'getTareaByTittle']);
    Route::put('/{id}',[TareaController::class,'update']);
    Route::put('/completar/{id}',[TareaController::class,'updateTareaCompleted']);
    Route::delete('/{id}',[TareaController::class,'delete']);
});