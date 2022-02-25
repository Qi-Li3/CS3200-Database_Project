#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr 18 22:38:43 2021

@author: liqi
"""

import pymysql
import math
import numpy as np
import matplotlib.pyplot as plt


try:
    cnx = pymysql.connect(host='localhost', user='root',
                          password='Dce7A219b',
                      db='movie', charset='utf8mb4',
                          cursorclass=pymysql.cursors.DictCursor)

except pymysql.err.OperationalError as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
 





#%%
'''user sign up'''
try:
    def user_sign_up(username,password):
        cur = cnx.cursor()
        insert_values = [username,password]
        cur.callproc('new_username',insert_values)
        text = cur.fetchall()
        cur.close()
        return text
    
    def change_password(input_username,new_password):
        cur = cnx.cursor()
        args = [input_username,new_password]
        cur.callproc('update_password',args)
        cur.close()
        
    def delete_accounts(username):
        cur = cnx.cursor()
        args = [username]
        cur.callproc('delete_account',args)
        cur.close()
        
    # user_sign_up('2','d')
    # user_sign_up('wfwf','23r2fde')

except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
    
    
    

#%%
try:
    def add_to_favorite_list(username,movie_title):
        title = [movie_title]
        cursor = cnx.cursor()
        query = "SELECT imdb_title_id FROM IMDb_movies WHERE title=%s"
        cursor.execute(query, title)
        a = cursor.fetchall()
        cursor.close()
        if a != ():
            imdn_id = a[0]['imdb_title_id']
        else:
            imdn_id = 'N/A'
        
        cur3 = cnx.cursor()
        insert_value = [username,movie_title,imdn_id]
        cur3.callproc('insert_into_favorite',insert_value)
        mes = cur3.fetchall()
        
        return mes


except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))    



#%%
try:
    def basic_movie_info_search(movie_title):
    
        args = []
        args.append(movie_title)
        cbasic_info = cnx.cursor()
        cbasic_info.callproc("basic_info", args) 

        print(cbasic_info.fetchall())
        cbasic_info.close()
    
    # basic_movie_info_search('alice')
    
except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
 
    
 
#%%
'''Filter'''
    
try:    
    def filter_by_multiple(director='   ', actors='   ', genre='   ', min_rate = 0):
        
        movie_list = set()
        
        di_args = []
        di_args.append(director)
        di = cnx.cursor()
        di.callproc('filter_by_director',di_args)
        for row in di.fetchall():
            if row['title'] != 'Nothing Founded' and row['avg_vote'] >= min_rate:
                movie_list.add(row['title'])   
        di.close()
        
        act_args = []
        act_args.append(director)
        act = cnx.cursor()
        act.callproc('filter_by_mainactor',di_args)
        for row in act.fetchall():
            if row['title'] != 'Nothing Founded' and row['avg_vote'] >= min_rate:
                movie_list.add(row['title'])
        act.close()
                
        gen_args = []
        gen_args.append(director)
        gen = cnx.cursor()
        gen.callproc('filter_by_genre',di_args)
        for row in gen.fetchall():
            if row['title'] != 'Nothing Founded' and row['avg_vote'] >= min_rate:
                movie_list.add(row['title'])
        gen.close()
        print(movie_list)


    # filter_by_multiple('alice','alice','action',8)
    
except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
    
 
    
#%%
try:
    def find_platform(movie_title):
        cur = cnx.cursor()
        args = [movie_title]
        cur.callproc('platform',args)
        result = cur.fetchall()
        cur.close()
        return result
    
except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))

#%%
try:
    def find_bio(name_of_person):
        name = [name_of_person]
        cursor = cnx.cursor()
        query = "SELECT people_bio(%s)"
        cursor.execute(query, name)
        a = cursor.fetchall()
        cursor.close()
        return a
    
except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))



#%%
try:
    def rotten_tomatoes_review(movie_title):
        cur = cnx.cursor()
        args = [movie_title]
        cur.callproc('rotten_tomatoes_review',args)
        result = cur.fetchall()
        cur.close()
        return result
    
except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
    
    
 
#%%    
'''Recommendation System
    Two Recommendation Method
'''    
 
# Recommendation based on people's favarite list 
try:
    def find_unique_interests(user_interests):
        """ Extract and return a set of unique user interests. """
        unique = set()
    
        for user in user_interests:
            for interest in user:
                unique.add(interest)
        return unique



# User Interests => word vector


    def vec(words, all_words):
        """ Vectorize a list of words:
        1 = word at position i in all_words is also in words
        0 = word at position i in all_words is not in words
        """
        
        return [1 if word in words else 0
                for word in all_words]


    def mag(v):
        """ magnitude of a vector """
        return sum([i **2 for i in v]) ** 0.5


    def dot(u,v):
        """ dot product of two vectors """
        return sum([ui * vi for ui, vi in zip(u,v)])
  

# Cosine similarity

    def cosine_similarity(u, v):
        """ Cosine similarity of two vectors, where:
            cos(theta)  = u dot v / (|u| |v| )
            """
        cos_theta = dot(u,v)/(mag(u) * mag(v))
        return cos_theta



    def make_similarity_matrix(user_interests):
        """ Compute the pair-wise cosine similarity of all the users """
    
        unique = find_unique_interests(user_interests)
    
        num_users = len(user_interests)
        simarray = np.zeros((num_users, num_users), dtype=float)

        for i in range(num_users):
            for j in range(num_users):
                simarray[i,j] = cosine_similarity(vec(user_interests[i], unique), vec(user_interests[j], unique))
            
        return simarray

    
    def recommendation_favorite_list(username,amount):
        cur = cnx.cursor()
        stmt_select = "select * from users_favorite_list order by username"
        cur.execute(stmt_select)
        flist = cur.fetchall()
        
        total_dic = {}
        total_list = []
        single_user_list = []
        last_user = flist[0]['username']
        for m in flist:
            if m['username'] == last_user:
                single_user_list.append(m['movie_title'])
            else:
                total_dic[last_user] = single_user_list
                total_list.append(single_user_list)
                single_user_list = []
                single_user_list.append(m['movie_title'])
            last_user = m['username']
        total_dic[last_user] = single_user_list
        total_list.append(single_user_list)
        
        input_user = total_dic[username]
        total_dic.pop(username)
        unique = find_unique_interests(total_list)
        
        sim_movie_list = []
        min_sim = 0
        for name in total_dic.keys():
            sim = cosine_similarity(vec(input_user, unique), vec(total_dic[name], unique))
            if sim > min_sim:
                min_sim = sim
                for moiv in total_dic[name]:
                    sim_movie_list.append(moiv)
        
        recommendation = []
        for movie in sim_movie_list:
            if movie not in input_user:
                recommendation.append(movie)
                
        print(recommendation[:amount])
    
    # recommendation_favorite_list('3',1)
    # recommendation_favorite_list('3',2)
    
except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
    
#%%
'''recommendation based on multi-dimentional ratings'''

try:
    
    cur = cnx.cursor()
    stmt_select = "select * from users_favorite_list order by username"
    cur.execute(stmt_select)
    flist = cur.fetchall()
        
    def recommendation_basedon_ratingStatistics(movie_title,No_of_recommendation):
        cur1 = cnx.cursor()
        title = [movie_title]
        cur1.callproc('get_genre_by_title',title)
        genre = cur1.fetchall()[0]['genre']
        cur1.close()
        
        same_genre_movie = set()

        cur2 = cnx.cursor()
        genre = [genre]
        cur2.callproc('filter_by_genre',genre)
        movies = cur2.fetchall()
        print(len(movies))
        for row in movies:
            same_genre_movie.add(row['title'])
        cur2.close()
        
        same_genre_movie = list(same_genre_movie)
        
        cur3 = cnx.cursor()
        cur3.callproc('rating_statics_with_runtime',title)
        local_stats = cur3.fetchall()[0]
        cur3.close()
        
        
        same_genre_movie = same_genre_movie[:150]
        
        dist = {}
        for i in range(len(same_genre_movie)):
            diff_total = 0
            t = [same_genre_movie[i]]
            cur4 = cnx.cursor()
            cur4.callproc('rating_statics_with_runtime',t)
            compare_stats = cur4.fetchall()[0]
            
            for key in compare_stats.keys():
                diff = (local_stats[key]-compare_stats[key])**2
                diff_total = diff_total + diff
                distance = math.sqrt(diff_total)
                
            if distance != 0:
                dist[same_genre_movie[i]] = distance
                sorted_dist = {k: v for k, v in sorted(dist.items(), key=lambda item: item[1])}
                recommendation=[k  for k in sorted_dist.keys()]

            cur4.close()
        
        return recommendation[:No_of_recommendation]
    


    # recommendation_basedon_ratingStatistics('Cleopatra',3)
    
    

except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))

#%%
try:
    def get_comparision_figure(movie1,movie2):
        cur1 = cnx.cursor()
        title1 = [movie1]
        cur1.callproc('rating_statics_without_runtime',title1)
        t1_stat = cur1.fetchall()
        
        cur2 = cnx.cursor()
        title2 = [movie2]
        cur2.callproc('rating_statics_without_runtime',title2)
        t2_stat = cur2.fetchall()
        
        xticks = []
        for key in t1_stat[0].keys():
            if type(t1_stat[0][key]) != str:
                xticks.append(key)
        
        t1_rating = []
        for v in t1_stat[0].values():
            if type(v) != str:
                t1_rating.append(v)
        
        t2_rating = []
        for v in t2_stat[0].values():
            if type(v) != str:
                t2_rating.append(v)
         
        X_axis = np.arange(len(xticks))
      
        bar1 = plt.bar(X_axis - 0.2, t1_rating, 0.4, label = title1)
        bar2 = plt.bar(X_axis + 0.2, t2_rating, 0.4, label = title2)
         
        plt.xticks(X_axis, xticks, fontsize=18)
        plt.xlabel("Rating groups based on Genders, Ages")
        plt.ylabel("Average Rating")
        plt.title("Rating Comparison")
        plt.xticks(rotation = 90)
        
        for bar in bar1:
            yval = bar.get_height()
            plt.text(bar.get_x(), yval + .1, round(yval, 2), fontsize = 9.5, ha='left')
            
        for bar in bar2:
            yval = bar.get_height()
            plt.text(bar.get_x(), yval + .1, round(yval, 2), fontsize = 9.5, ha='left')
            
        plt.gcf().set_size_inches(15,10)
        plt.legend(title = 'Movie Title', bbox_to_anchor=(1.02, 1), loc='upper left',fancybox=True, shadow=True, fontsize=12)
        plt.show()
    
    get_comparision_figure('Cleopatra','Miss Jerry')
    

except pymysql.Error as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))
    
