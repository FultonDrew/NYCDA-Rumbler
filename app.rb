require 'sinatra'
require 'sinatra/activerecord'


set :database, 'sqlite3:DrewBlog.sqlite3'
set :sessions, true

require './models'

def current_blog
	@blog = Blog.find(params[:id])
end


def current_user
	@users = User.all
	@blogs = Blog.all
		if (session[:user_id])
		@currentuser = (session[:user_id])

	end
end

get "/" do 
	@users = User.all
	@currentuser = (session[:user_id])
	@blogs = Blog.all
	erb :homepage
	
end

get "/loginpage" do 
	@users = User.all
	@currentuser = (session[:user_id])
	@blogs = Blog.all
	erb :loginpage
	
end

get '/users/:id' do
	@user = User.find(params[:id])
	@blogs = Blog.all
	erb :user
end

get "/blogs/:id" do
	@blog = Blog.find(params[:id])
	erb :specificblog
end

get '/newpost' do
	erb :newpost
end

get "/blogs/:id/edit" do
	@blog = Blog.find(params[:id])
	erb :editpost
end

get "/userpage" do
	erb :userpage
end


post '/signup' do
	username = params[:username]
	password = params[:password]
	fname = params[:fname]
	lname = params[:lname]
	email = params[:email]

	user = User.new(username: username, password: password, fname: fname, lname: lname, email: email)
	if user.save
			redirect "/"
		else
			erb :homepage
		end
end

post '/loginpage' do
	@users = User.all
	user = User.where(username: params[:username]).first
		erb :loginpage
end

post '/login' do
	@users = User.all
	user = User.where(username: params[:username]).first
	if user.password == params[:password]
		session[:user_id] = user
		redirect "users/#{user.id}"
	else
		erb :homepage
	end
end

post "/create_blog" do

	if !session[:user_id]
			redirect "/"
	end
		title = params[:title]
		content = params[:content]
		user = session[:user_id]
	Blog.create(title: title, content: content, user_id: user.id)
	redirect "/"
end

post "/update/:id" do
	@blog = Blog.find(params[:id])
	if @blog.update(title: params[:title], content: params[:content])
		redirect "/"
	else
		erb "/blogs/<%= @blog.id %>/edit"
	end
end

post "/destroy/:id" do
	@blog = Blog.find(params[:id])
	if @blog.destroy
		redirect "/"
	end
end

post '/logout' do
	session[:user_id] = nil
	redirect "/"
	
end

