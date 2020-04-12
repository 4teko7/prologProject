% Bilal Tekin
% 2017400264
% compiling: yes
% complete: yes

% artist(ArtistName, Genres, AlbumIds).
% album(AlbumId, AlbumName, ArtistNames, TrackIds).
% track(TrackId, TrackName, ArtistNames, AlbumName, [Explicit, Danceability, Energy,
%                                                     Key, Loudness, Mode, Speechiness,
%                                                     Acousticness, Instrumentalness, Liveness,
%                                                     Valence, Tempo, DurationMs, TimeSignature]).








features([explicit-0, danceability-1, energy-1,
          key-0, loudness-0, mode-1, speechiness-1,
       	  acousticness-1, instrumentalness-1,
          liveness-1, valence-1, tempo-0, duration_ms-0,
          time_signature-0]).

filter_features(Features, Filtered) :- features(X), filter_features_rec(Features, X, Filtered).
filter_features_rec([], [], []).
filter_features_rec([FeatHead|FeatTail], [Head|Tail], FilteredFeatures) :-
    filter_features_rec(FeatTail, Tail, FilteredTail),
    _-Use = Head,
    (
        (Use is 1, FilteredFeatures = [FeatHead|FilteredTail]);
        (Use is 0,
            FilteredFeatures = FilteredTail
        )
    ).




% artist(ArtistName, Genres, AlbumIds).
% album(AlbumId, AlbumName, ArtistNames, TrackIds).
% track(TrackId, TrackName, ArtistNames, AlbumName, [Explicit, Danceability, Energy,
%                                                     Key, Loudness, Mode, Speechiness,
%                                                     Acousticness, Instrumentalness, Liveness,
%                                                     Valence, Tempo, DurationMs, TimeSignature]).


% getArtistTracks(+ArtistName, -TrackIds, -TrackNames) 5 points
getArtistTracks(ArtistName, TrackIds, TrackNames) :-
    findAllTracksIdsAndTrackNamesWithArtistName(ArtistName,TrackIds,TrackNames).

% Human and What he likes
findAllTracksIdsAndTrackNamesWithArtistName(ArtistName,TrackIds,TrackNames) :- 
    findall(TrackIds, ( track(TrackIds,_,[ArtistName|_],_,_) ), TrackIds),
    findall(TrackNames, ( track(_,TrackNames,[ArtistName|_],_,_) ), TrackNames).



findAllTrackFeaturesWithAlbumName(AlbumName,AlbumFeatures):-
    findall(AlbumFeatures, ( track(_,_,_,AlbumName,AlbumFeatures) ), AlbumFeatures).


albumFeatures(AlbumId, AlbumFeatures) :-
    album(AlbumId,AlbumName,_,_),
    findAllTrackFeaturesWithAlbumName(AlbumName,TempAlbumFeatures),
    nestedListToSingleList(TempAlbumFeatures,AverageFeatures),
    filter_features(AverageFeatures,TempAlbumFeatures2),
    listLength(TempAlbumFeatures,Length),
    averageOfListLengthGiven(TempAlbumFeatures2,Length,AlbumFeatures),!.



% Average Of A List With Length Given.
averageOfListLengthGiven([],_,[]).
averageOfListLengthGiven([H|T],Length,AlbumFeatures):-
    averageOfListLengthGiven(T,Length,AlbumFeatures2),
    M is H / Length,
    AlbumFeatures = [M|AlbumFeatures2].



% Add All Lists' Elements Inside One Nested Main List. For example, 1. element of 1. list and 1. element of 2. list will be added.
% Result will be Only One List.
nestedListToSingleList([],[]).
nestedListToSingleList([H|T],AverageFeatures):-
    nestedListToSingleList(T,AverageFeatures2),
    addTwoList(H,AverageFeatures2,AverageFeatures).


% Add Two List.
addTwoList([],[],[]).
addTwoList(H,[],ResultList):- ResultList = H.
addTwoList([H1|T1],[H2|T2],ResultList):-
    addTwoList(T1,T2,ResultList2),
    M is H1 + H2,
    ResultList = [M|ResultList2].


% Gives Length Of Any List.
listLength([], 0 ).
listLength([_|OurList], X) :- 
    listLength(OurList,N) , X is N+1 .


writeToFile(X):-
    open('writtenThing.txt', append, Stream), write(Stream,X), write(Stream,'\n'),close(Stream).


% Append Two Lists [1,2,3] + [5,6] = [1,2,3,5,6]
append([],L2,L2).
append([H|T],L2,[H|L3]) :- append(T,L2,L3).

% albumFeatures(+AlbumId, -AlbumFeatures) 5 points
% artistFeatures(+ArtistName, -ArtistFeatures) 5 points

% trackDistance(+TrackId1, +TrackId2, -Score) 5 points
% albumDistance(+AlbumId1, +AlbumId2, -Score) 5 points
% artistDistance(+ArtistName1, +ArtistName2, -Score) 5 points

% findMostSimilarTracks(+TrackId, -SimilarIds, -SimilarNames) 10 points
% findMostSimilarAlbums(+AlbumId, -SimilarIds, -SimilarNames) 10 points
% findMostSimilarArtists(+ArtistName, -SimilarArtists) 10 points

% filterExplicitTracks(+TrackList, -FilteredTracks) 5 points

% getTrackGenre(+TrackId, -Genres) 5 points

% discoverPlaylist(+LikedGenres, +DislikedGenres, +Features, +FileName, -Playlist) 30 points

