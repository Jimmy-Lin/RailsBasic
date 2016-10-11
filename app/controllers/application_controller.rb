class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def must_be_logged_in
  	if !is_logged_in?
			store_location
		    flash[:danger] = "Please log in."
		    redirect_to login_url
  		end
	end

  def has_access?(user, operation, object)

    #Access depends on operation and class
    #Should order cases by frequency

    case operation
    when "Read"
      has_read_access?(user, object)
    when "Create"
      has_create_access?(user, object)
    when "Delete"
      has_delete_access?(user, object)
    when "Update"
      has_update_access?(user, object)

    else 
      # Error handler
    end

  end

  private

    def is_user?
      return is_logged_in?
    end

    def is_member?(user, object)
      case object.class
      when User
        return object.groups.any?{ |group| group.members.include?(user) }
      when Group
        return object.members.include?(user)
      when Event, Announcement, Folder, Membership
        return object.group.members.include?(user)
      when Attendance
        return object.event.group.members.include?(user)
      when Document, Link
        return object.folder.group.members.include?(user)
      when Message
        return object.conversation.messages.any?{ |message| message.creator == user }
      when Conversation
        return object.messages.any?{ |message| message.creator == user }
      else
        return false
      end
    end

    def is_creator?(user, object)
      case object.class
      when User
        return object == user
      when Group,
        return object.creator == user
      when Event, Announcement, Folder
        return object.creator == user || object.group.creator == user
      when Attendance
        return object.user == user || object.event.creator ==  user || object.event.group.creator == user
      when Membership
        return object.user == user || object.group.creator == user
      when Document, Link
        return object.creator ==  user || object.folder.creator == user || object.folder.group.creator == user
      when Message
        return object.creator == user
      when Conversation
        return false
      else
        return false
      end
        
    end

    def is_admin?(user)
      return user.is_admin?
    end

    def has_access_level?(user, object, access_level)
      case access_level
      when "public"
        return true
      when "users_only"
        return is_user?
      when "members_only"
        return is_user? && ( is_member?(user, object) || is_creator?(user, object) || is_admin?(user) )
      when "creators_only"
        return is_user? && ( is_creator?(user) || is_admin?(user) )
      when "admin_only"
        return is_user? && is_admin?(user)
      else
        return true
      end
    end
        
    end

    def has_create_access?(user, object)
      case object.class
      when Message, Conversation, Membership, Group
        return has_access_level?(user, object, "users_only")
      when Attendance
        return object.is_public? && has_access_level?(user, object, "users_only") || has_access_level?(user, object, "members_only")
      when Event, Announcement, Document, Link, Folder
        return has_access_level?(user, object, "members_only")
      when User
        return has_access_level?(user, object, "admin_only")
      else
        return false
      end
    end

    def has_read_access?(user, object)
      case object.class
      when Group, User
        return has_access_level?(user, object, "users_only")
      when Event, Announcement
        return object.is_public? || has_access_level?(user, object, "members_only")
      when Attendance, Message, Conversation, Document, Link, Folder, Membership
        return has_access_level?(user, object, "members_only")
      else
        return false
      end
    end

    def has_update_access?(user, object)
      case object.class
      when Attendance, Event, Anouncement, Message, Document, Link, Folder, Membership, Group, User
        return has_access_level?(user, object, "creators_only")
      when Conversation
        return false
      else
        return false
      end
    end

    def has_delete_access?(user, object)
      case object.class
      when Attendance, Event, Anouncement, Message, Document, Link, Folder, Membership, Group, User
        return has_access_level?(user, object, "creators_only")
      when Conversation
        return false
      else
        return false
      end
    end
end
