install.packages("e1071") 

library("e1071")
high_attention_train_data = read.table("/Users/Rudra/Desktop/quarter 2/BCI Project/High attention/RidyattentionGOOD1.txt")
high_attention_train_data=data.frame(high_attention_train_data)
###### data frame manipulation
high_attention_train_data<-high_attention_train_data[!(high_attention_train_data$V26!=0 ),]
keeps <- c("V10") ####"V22","V47" for meditation and time 
high_attention_train_data=high_attention_train_data[keeps] #### Keep specified columns

## rename columns
names(high_attention_train_data) <- c("Attention")
#### statistics
high_attention_train_data$Class <- rep(2,nrow(high_attention_train_data))
high_attention_train_data<-high_attention_train_data[-(1:5),]

################

low_attention_train_data = read.table("/Users/Rudra/Desktop/quarter 2/BCI Project/Low attention/RidylowattentionGOOD2.txt")
low_attention_train_data=data.frame(low_attention_train_data)
low_attention_train_data<-low_attention_train_data[!(low_attention_train_data$V26!=0 ),]
###### data frame manipulation
keeps <- c("V10")
low_attention_train_data=low_attention_train_data[keeps] #### Keep specified columns
## rename columns
names(low_attention_train_data) <- c("Attention")
#### statistics
low_attention_train_data$Class <- rep(1,nrow(low_attention_train_data))
low_attention_train_data<-low_attention_train_data[-(1:5),]

######### high meditation ############

high_meditation_train_data = read.table("/Users/Rudra/Desktop/quarter 2/BCI Project/High attention/RidyattentionGOOD1.txt")
high_meditation_train_data=data.frame(high_meditation_train_data)
###### data frame manipulation
high_meditation_train_data<-high_meditation_train_data[!(high_meditation_train_data$V26!=0 ),]
keeps <- c("V22") ####"V22","V47" for meditation and time 
high_meditation_train_data=high_meditation_train_data[keeps] #### Keep specified columns

## rename columns
names(high_meditation_train_data) <- c("Meditation")
#### statistics
high_meditation_train_data$Class <- rep(2,nrow(high_meditation_train_data))
high_meditation_train_data<-high_meditation_train_data[-(1:5),]


################### low meditation ##########



low_meditation_train_data = read.table("/Users/Rudra/Desktop/quarter 2/BCI Project/Low attention/RidylowattentionGOOD2.txt")
low_meditation_train_data=data.frame(low_meditation_train_data)
low_meditation_train_data<-low_meditation_train_data[!(low_meditation_train_data$V26!=0 ),]
###### data frame manipulation
keeps <- c("V22")
low_meditation_train_data=low_meditation_train_data[keeps] #### Keep specified columns
## rename columns
names(low_meditation_train_data) <- c("Meditation")
#### statistics
low_meditation_train_data$Class <- rep(1,nrow(low_meditation_train_data))
low_meditation_train_data<-low_meditation_train_data[-(1:5),]


##### plot data

# x=NROW(high_attention_train_data)
# x=1:x
# 
# plot(x,low_attention_train_data[,c("Attention")],"l",col="red", ylim=c(0, 100)) 
# lines(x,high_attention_train_data[,c("Attention")],"l",col="blue")


##########
#### Statistics
# 
# mean(high_attention_train_data[,c("Attention")])
# sd(high_attention_train_data[,c("Attention")])
# mean(low_attention_train_data[,c("Attention")])
# sd(low_attention_train_data[,c("Attention")])

######################
high_attention_train_data=as.data.frame(high_attention_train_data)
low_attention_train_data=as.data.frame(low_attention_train_data)
high_meditation_train_data=as.data.frame(high_meditation_train_data)
low_meditation_train_data=as.data.frame(low_meditation_train_data)
overall_attention=rbind(high_attention_train_data,low_attention_train_data)
overall_meditation=rbind(high_meditation_train_data,low_meditation_train_data)


################# svm   ############


svm_tune_attention <- tune(svm, train.x=overall_attention[,c("Attention")], train.y=overall_attention[,c("Class")], 
                 kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))
svm_results_attention<- svm(overall_attention[,c("Attention")],overall_attention[,c("Class")],kernel="radial",cost=svm_tune_attention$best.parameters$cost,gamma=svm_tune_attention$best.parameters$gamma)


svm_tune_meditation <- tune(svm, train.x=overall_meditation[,c("Meditation")], train.y=overall_meditation[,c("Class")], 
                            kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))
svm_results_meditation<- svm(overall_meditation[,c("Meditation")],overall_meditation[,c("Class")],kernel="radial",cost=svm_tune_meditation$best.parameters$cost,gamma=svm_tune_meditation$best.parameters$gamma)


####################################
state_array_attention=c(1,1,1,0,0)
state_array_meditation=c(1,1,1,0,0)
state_attention = 0
state_meditation = 0
i=1
while(i==1)
{
  ######
  #python function call from consider
  #########
  ############# read live txt data 
  live = read.table("### temp attention####")
  live =data.frame(live)
  if (live$V26==0 )
  {
    predictedY_attention <- round(predict(svm_results_attention,live$V10),digits=0)
    predictedY_meditation <- round(predict(svm_results_meditation,live$V22),digits=0)
    state_array_attention = state_array_attention[-1]
    state_array_meditation = state_array_meditation[-1]
    state_array_attention = c(state_array_attention,predictedY_attention)
    state_array_meditation = c(state_array_meditation,predictedY_meditation)
    if(sum(state_array_attention>3))
    {
      state_attention=1
    }
    else if (sum(state_array_attention<3))
    {
      state_attention=0
    }
    
    if(sum(state_array_meditation>3))
    {
      state_meditation=1
    }
    else if ((sum(state_array_meditation<3)))
    {
      state_meditation=0
    }
  }
  ######### the states map to the bot and move it 
  ############### blink needs another loop
}

