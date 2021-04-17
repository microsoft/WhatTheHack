"use strict";
class MinimizableWebChat {
    Minimize = null;
    Maximize = null;
    ChatFrame = null;
    Root = null;
    WebChat = null;
    Connected = false;
    Authenticated = false;

    #HtmlTemplate = `<div class="minimizable-web-chat">    
    <button class="maximize">
        <img alt="beanie icon" style="margin-top: -30px;margin-left: -10px;"
            src="https://virtualworkfriendbotz7sw.blob.core.windows.net/images/BotIcon.png" width="50" height="50">
    </button>
    <div class="chat-box right hide">
        <header>
            <div class="filler"></div>
            <button class="minimize"><span class="ms-Icon ms-Icon--ChromeMinimize"></span></button>
        </header>
        <div class="webchat"></div>
    </div>
</div>`;
    DefaultStyleOptions = {
        botAvatarImage: 'https://virtualworkfriendbotz7sw.blob.core.windows.net/images/BotInitials.png',
        botAvatarInitials: 'B',
        userAvatarInitials: 'You',
        backgroundColor: '#E6F8FE',
        bubbleBackground: '#E6E6E6',
        bubbleTextColor: 'black',
        bubbleFromUserBackground: '#9BEFD9',
        hideUploadButton: true,
    };
    StyleOptions = null;
    WebChatStyleOptions = null;
    constructor(rootDivId, authenticate, autoConnect, styleOptions) {
        this.Root = $('#' + rootDivId);
        this.Initialize();
        this.StyleOptions = (styleOptions == undefined) ? this.DefaultStyleOptions : styleOptions;
        var callConnect = true;
        if (autoConnect != undefined) {
            callConnect = Boolean(autoConnect);
        }
        if (authenticate != undefined) {
            this.Authenticated = Boolean(authenticate);
        }
        if (callConnect) {
            this.Connect();
        }
    }
    Initialize() {
        this.Root.html(this.#HtmlTemplate);
        this.Maximize = $(this.Root).find("button.maximize");
        this.Minimize = $(this.Root).find("button.minimize");
        this.ChatFrame = $(this.Root).find("div.chat-box");
        this.WebChat = $(this.Root).find("div.webchat");
        this.Maximize.click(e => { this.ShowChat(); });
        this.Minimize.click(e => { this.HideChat(); });
    }
    ShowChat() {
        this.Maximize.addClass("hide");
        this.ChatFrame.removeClass("hide");
        if (!this.Connected) {
            this.Connect();
        }
        this.WebChat.find("input").focus();
    }
    HideChat() {
        this.ChatFrame.addClass("hide");
        this.Maximize.removeClass("hide");
    }
    #SpeechFactory = null;
    #BotStore = null;
    #DirectLineToken = null;
    #UserId = null;
    Locale = "en-US";
    TokenGenerationBase = "https://ocpbtg.azurewebsites.net";
    DomainId = null;
    EnableSpeech = false;

    Connect() {
        if (this.Connected) {
            return;
        }
        var chatControl = this;

        if (this.EnableSpeech) {
            var speechTokenUrl = "/api/tokens/speech";
            if (this.DomainId != null)
            {
                speechTokenUrl = this.TokenGenerationBase + "/api/speech/" + this.DomainId;
            }
    
            $.post(speechTokenUrl, async function (speechToken) {
                chatControl.#SpeechFactory = await window.WebChat.createCognitiveServicesSpeechServicesPonyfillFactory({
                    credentials: speechToken
                });
                chatControl.#ConnectWebChat(chatControl);            
            });
        }
        else {
            chatControl.#ConnectWebChat(chatControl);  
        }

        chatControl.Root[0].addEventListener('WebChatUIUpdate', ({ data }) => {
            //console.log(`Received an activity of type "${data.type}":`);
            //console.log(data);
            this.WebChatStyleOptions = data.value;
            this.UpdateUI(data.sender, data.value, this);
        });
        
    }
    #ConnectWebChat(chatControl) {
        var tokenUrl = "/api/tokens";
        if (chatControl.Authenticated) {
            tokenUrl += "/authenticate";
        }

        if (chatControl.DomainId != null)
        {
            tokenUrl = chatControl.TokenGenerationBase + "/api/token/" + chatControl.DomainId;
        }

        $.post(tokenUrl, async function (config) {
            // We are using a customized store to add hooks to connect event
            chatControl.#BotStore = window.WebChat.createStore({}, ({ dispatch }) => next => action => {
                if (action.type === 'DIRECT_LINE/CONNECT_FULFILLED') {
                    // When we receive DIRECT_LINE/CONNECT_FULFILLED action, we will send an event activity using WEB_CHAT/SEND_EVENT
                    dispatch({
                        type: 'WEB_CHAT/SEND_EVENT',
                        payload: {
                            name: 'webchat/join',
                            value: { language: window.navigator.language }
                        }
                    });
                }
                if (action.type === 'DIRECT_LINE/INCOMING_ACTIVITY') {
                    var activity = action.payload.activity;
                    if (activity.type == "event") {
                        var eventName = activity.name;
                        if (eventName == "UPDATE_UI") {
                            const event = new Event('WebChatUIUpdate');

                            event.data = {
                                type: 'WebChatUIUpdate',
                                sender: chatControl,
                                value: JSON.parse(activity.value)
                            };
                            chatControl.Root[0].dispatchEvent(event);
                        }
                    }
                    else if (activity.type == "message") {
                        //console.log(activity);
                        //chatControl.Render(chatControl);
                    }
                    
                }

                return next(action);
            });
            chatControl.#DirectLineToken = window.WebChat.createDirectLine({
                token: ((config.Token != undefined) ? config.Token : config.token)
            });
            chatControl.#UserId = (config.UserId != undefined) ? config.UserId : config.userId;
            chatControl.Render(chatControl);
            chatControl.Connected = true;
        });
    }
    Render(chatControl) {
        if (chatControl.#SpeechFactory != null)
        {
            window.WebChat.renderWebChat(
                {
                    directLine: chatControl.#DirectLineToken,
                    userID: chatControl.#UserId,
                    locale: chatControl.Locale,
                    styleOptions: {
                        ...chatControl.StyleOptions
                    },
                    store: chatControl.#BotStore,
                    webSpeechPonyfillFactory: chatControl.#SpeechFactory
                },
                chatControl.WebChat[0]);
        }
        else
        {
            window.WebChat.renderWebChat(
                {
                    directLine: chatControl.#DirectLineToken,
                    userID: chatControl.#UserId,
                    locale: chatControl.Locale,
                    styleOptions: {
                        ...chatControl.StyleOptions
                    },
                    store: chatControl.#BotStore
                },
                chatControl.WebChat[0]);
        }
        
    }
    

    UpdateUI = function (control, data, wrapper) {        
        control.StyleOptions = data;
        control.Render(control);        
    }
}
