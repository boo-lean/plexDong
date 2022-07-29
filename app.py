from flask import Flask, redirect, url_for
from flask import render_template
from werkzeug.exceptions import NotFound

from main import single_query, create_dong, get_all, check_if_exist

app = Flask(__name__)


@app.route('/')
def index():
    try:
        default = 'Enter a Username/Email &#128522;'
        return render_template('index.html', default=default, isIndex=True)
    except NotFound as e:
        print(e)


# Display full dong leaderboard
@app.route('/dongs', strict_slashes=False, methods=['GET'])
def all_dong():
    all_names, all_dongs = get_all()
    return render_template('all_dongs.html',
                           all_names=all_names,
                           all_dongs=all_dongs, zip=zip, isIndex=False)


# Display dong by email/username
@app.route('/dongs/<email>', strict_slashes=False, methods=['GET'])
def display_dong(email):
    if check_if_exist(email):
        plays, username = single_query(email)
        dong = create_dong(plays)
        all_names, all_dongs = get_all()
        statement = '{0} you have '.format(username) + plays + ' plays, therefore '
        return render_template('get_dong.html', statement=statement, dong=dong, title='| ' + email,
                               all_names=all_names,
                               all_dongs=all_dongs, zip=zip, isIndex=False)
    else:
        msg = '<p style="color:red;">User not found</p><br />'
        return render_template('index.html', default=msg, title='| Error', isIndex=True)


# Handles an error that is produced when an invalid email/username is entered
@app.errorhandler(500)
def internal_error(error):
    msg = '<p style="color:red;">' + str(error) + '</p><br />'
    return render_template('index.html', default=msg, title='| Error', isIndex=True)


@app.errorhandler(404)
def err_404(error):
    msg = f'<p style="color:red;">{str(error)}.</p><br />'
    return render_template('index.html', default=msg, title='| Error', isIndex=True)


# Allows for values to be zipped in the flask for-loop templates
@app.template_global(name='zip')
def _zip(*args, **kwargs):
    return __builtins__.zip(*args, **kwargs)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8787)
