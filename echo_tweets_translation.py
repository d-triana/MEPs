# -*- coding: utf-8 -*-
"""
Created on Wed Jul 27 11:50:55 2022

@author: Daniel Triana
"""

# %%
from typing import Union, Any

import pandas as pd
from pandas import DataFrame, Series
from pandas.core.generic import NDFrame
from pandas.io.parsers import TextFileReader
import numpy as np
import matplotlib.pyplot as plt
import pyreadr
import deep_translator
import deep_translator.base
import deep_translator.exceptions
from deep_translator import GoogleTranslator, single_detection, batch_detection
import requests
import time

# %%

# Load the DataBase
tweets_text: Union[Union[TextFileReader, DataFrame], Any] = pd.read_csv(r'tweets_text.csv', low_memory=False)
tweets_text[['true_author_id', 'id', 'conversation_id', 'commission_dummy', 'party_id', 'in_reply_to_user_id'
             ]] = tweets_text[['true_author_id', 'id', 'conversation_id', 'commission_dummy', 'party_id',
                               'in_reply_to_user_id']].astype(str)

# File with the international language codes for reference
lang_codes = pd.read_csv(r'language_codes.csv')

# Create object to know how many tweets per language are in the DataBase
tweets_per_language = (tweets_text['lang'].value_counts())



# %%
#german = tweets_text.query('lang =="de"')
german_2 = tweets_text.query('lang =="de"').iloc[4240:6000]
# text_1 = pd.DataFrame(test_1[["name","text"]])
# text_list = text_1['text'].values.tolist()

# %%

# Generate empty dataframe with the columns "text_original" & "text_translated"
df_Transl_2 = pd.DataFrame(columns=['text', 'text_translated'])

# for loop, translation process
print('Beginning translation...')
start = time.time()
for i, tweet in enumerate(german_2.text):
    if str(tweet) == 'nan':
        print('Reading task completed')
        break
    translation = GoogleTranslator().translate(text=tweet)
    a = 1

    # In case of no success, retries up to six times
    while tweet == translation:
        print('Could not translate the row ' + str(i) + ', retry ' + str(a))
        translator = GoogleTranslator(service_urls=[
            'translate.google.com',
            'translate.google.de',
            'translate.google.co.uk',
            'translate.google.co.kr',
            'translate.google.com.ec',
            'translate.google.com.mx',
            'translate.google.com.uy',
            'translate.google.cn'
        ])
        translation = GoogleTranslator().translate(text=tweet)
        a += 1
        if a > 6: break

    # Check if the text was translated
    if tweet == translation:
        print('Translation attempted on: ' + str(tweet) + ' Returned: ' + str(translation))
    print(i)
    # Populate Data Frame with the original text and the translation
    df_Transl_2.loc[i] = [tweet, translation]
print('... Task completed.')
end = time.time()
print("The time of execution is: ", end-start)

#%%

# Merge the DataFrames in order to have the translations in the same DataFrame
german_2 = pd.merge(german_2, df_Transl_2, on='text')

#%%

# Change the order of the DF columns for ease of comparison
german_2 = german_2[['true_author_id', 'name', 'username', 'day', 'month', 'year', 'dob', 'full_name', 'sex', 'country',
             'nat_party', 'nat_party_abb', 'eu_party_group', 'eu_party_abbr', 'commission_dummy', 'party_id',
             'engparty', 'party', 'eu_position', 'lrgen', 'lrecon', 'galtan', 'eu_eu_position', 'eu_lrgen',
             'eu_lrecon', 'eu_galtan', 'lang', 'text', 'text_translated', 'id', 'public_metrics.retweet_count',
             'public_metrics.reply_count', 'public_metrics.like_count', 'public_metrics.quote_count',
             'conversation_id', 'source', 'in_reply_to_user_id', 'geo.place_id', 'geo.coordinates.type',
             'created_at'
             ]]
#%%

# Save file
german_2.to_csv('german_2_translated.csv', index=False, encoding='utf-8-sig')
