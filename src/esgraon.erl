%%%-------------------------------------------------------------------
%%% @author Mario Georgiev
%%% @copyright (C) 2014, Mario Georgiev
%%% Copyright (c) 2014, Mario Georgiev
%%% All rights reserved.
%%%
%%% Redistribution and use in source and binary forms, with or without
%%% modification, are permitted provided that the following conditions are met:
%%% * Redistributions of source code must retain the above copyright
%%% notice, this list of conditions and the following disclaimer.
%%% * Redistributions in binary form must reproduce the above copyright
%%% notice, this list of conditions and the following disclaimer in the
%%% documentation and/or other materials provided with the distribution.
%%% * Neither the name of the <organization> nor the
%%% names of its contributors may be used to endorse or promote products
%%% derived from this software without specific prior written permission.
%%%
%%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
%%% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%%% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%%% DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
%%% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
%%% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
%%% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
%%% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%%% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
%%% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%
%%% @doc
%%% ESGRAON: http://www.grao.bg/esgraon.html
%%% Additional: http://georgi.unixsol.org/programs/egn.php
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(esgraon).
-author("Mario Georgiev").

%% API
-export([test/0, validate/1, calculate/1, sex/1, region/1]).

test() ->
  X = validate("5605126389"),
  io:format("Check: ~p~n", [X]),
  Y = calculate("004624668"),
  io:format("Calc: ~p~n", [Y]),
  io:format("Sex: ~p~n", [sex("0046246676")]).

validate(ID) ->
  N = string_to_list(ID),
  {Head, Check} = lists:split(9, N),
  Result = calculate(list_to_string(Head)),
  lists:nth(1, Check) == Result.

sex(ID) ->
  N = string_to_list(ID),
  Rem = lists:nth(9, N) rem 2,
  if
    Rem == 0 ->
      male;
    Rem == 1 ->
      female
  end.

calculate(ID_head) ->
  N = string_to_list(ID_head),
  Weights = [2, 4, 8, 5, 10, 9, 7, 3, 6],
  Zip = lists:zip(N, Weights),
  Sum = lists:foldl(fun(Pair, Sum) -> {A, B} = Pair, X = A * B, X + Sum end, 0, Zip),
  Res = Sum rem 11,
  if
    Res == 10 ->
      0;
    Res < 10 ->
      Res
  end.

string_to_list(S) ->
  [ list_to_integer([X]) || X <- S ].

list_to_string(L) ->
  lists:concat([ integer_to_list(X) || X <- L ]).

region(ID) ->
  N = string_to_list(ID),
  R = list_to_integer(lists:concat(lists:sublist(N, 7, 3))),
  lists:filtermap(fun(Reg) -> {region, _Name, _Short, Min, Max} = Reg, (R >= Min) and (R =< Max) end, regions()).

regions() ->
  [
    {region, "Благоевград", "E", 000, 043},   {region, "Бургас", "A", 044, 093},          {region, "Варна", "B", 094, 139},         {region, "Велико Търново", "BT", 140, 169},
    {region, "Видин", "BH", 170, 183},        {region, "Враца", "BP", 184, 217},          {region, "Габрово", "EB", 218, 233},      {region, "Кърджали", "K", 234, 281},
    {region, "Кюстендил", "KH", 282, 301},    {region, "Ловеч", "OB", 302, 319},          {region, "Монтана", "M", 320, 341},       {region, "Пазарджик", "PA", 342, 377},
    {region, "Перник", "PK", 378, 395},       {region, "Плевен", "EH", 396, 435},         {region, "Пловдив", "PB", 436, 501},      {region, "Разград", "PP", 502, 527},
    {region, "Русе", "P", 528, 555},          {region, "Силистра", "CC", 556, 575},       {region, "Сливен", "CH", 576, 601},       {region, "Смолян", "CM", 602, 623},
    {region, "София - град", "C", 624, 721},  {region, "София - област", "CO", 722, 751}, {region, "Стара Загора", "CT", 752, 789}, {region, "Добрич", "TX", 790, 821},
    {region, "Търговище", "T", 822, 843},     {region, "Хасково", "X", 844, 871},         {region, "Шумен", "H", 872, 903},         {region, "Ямбол", "Y", 904, 925},
    {region, "Друг", "", 926, 999}
  ].

