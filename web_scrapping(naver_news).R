library(rvest)

# popular news head ####################################
url_news <- "http://news.naver.com/main/ranking/popularDay.nhn?mid=etc&sid1=111&date=20170412"   # �� ��ũ������ �� url�� �Է��մϴ�.
news_data <- read_html(url_news)   # �Էµ� url���� html�� �о�ɴϴ�.

popular_new_head <- data.frame(Policy=c(1:5), Economy=NA, Society=NA, Life=NA, World=NA, IT=NA, TV_Ent=NA, Sports=NA)   # ������ 5���� �� ī�װ��� ���� �Է��ϴ� ������ �������� ����ϴ�.

for(i in 1:(nrow(popular_new_head))){   # 1~5���� ��忡 ���� for���Դϴ�.
  find_num <- paste0('.num',i)   # ������ ���� ��ȣ�� �ٸ��Ƿ� ��ȣ�� �ٲ� �� �ֵ��� �մϴ�. 
  num_head <- html_nodes(news_data, find_num)   # i�� 1�� ���, num1�� �ش��ϴ� ��带 ã�Ƴ��ϴ�. 
  
  for(j in 1:ncol(popular_new_head)){   # ��ġ ~ ������������ ī�װ����� ���� for���Դϴ�.
    head_text <- gsub("\t","",num_head[j] %>% html_text())   # j ��° ��忡�� text�� ������ �Ŀ� ��(\t)�� �����մϴ�.
    head_text <- strsplit(head_text, "\r\n")[[1]]   # text�� "\r\n"���� �����ݴϴ�. list�� ��ȯ�˴ϴ�. vector�� �ٲٱ� ���� [[1]]�� �ڿ� �ٿ��ݴϴ�.
    if(i==1){
      popular_new_head[i,j] <- head_text[12]    # ù ���� ī�װ����� ��ġ�� ���� 12��°�� �������� ����ֽ��ϴ�. �̸� �ռ� ������ ������ �����ӿ� �־��ݴϴ�.
    }else{
      popular_new_head[i,j] <- head_text[5]   # ������ ī�װ������� 5��°�� �������� ����ֽ��ϴ�. �̸� �ռ� ������ ������ �����ӿ� �־��ݴϴ�.
    }
  }
}

write.csv(popular_new_head,"popular_news_head.csv")   # csv ���Ϸ� �����մϴ�. ���丮 ������ ���ϸ� ���� ���� ���� ����˴ϴ�.


# paper news 1page top head ####################################
paper_oid <- read.csv("paper_oid.csv", header = TRUE, colClasses = c("character", "character", "character"))   # �����س��� oid�� ���Ե� csv�� �о���Դϴ�. oid�� ���ڷ� ������ �տ� 0�� ������Ƿ� colClasses�� ���� column�� Ÿ���� character�� �о���Դϴ�.
news_paper_top <- data.frame(Paper=paper_oid$Paper, A1_Top=NA)   # ��л纰�� 1���� �������� ������ ������ �������� ����ϴ�.

for(i in 1:nrow(news_paper_top)){
  url_news <- paste0("http://news.naver.com/main/list.nhn?oid=",paper_oid$oid[i],"&listType=paper&mid=sec&mode=LPOD&date=20170412")   # �� ��ũ������ �� url�� �Է��մϴ�.
  news_data <- read_html(url_news)   # �Էµ� url���� html�� �о�ɴϴ�.
  A1_nodes <- html_nodes(news_data, '.type13.firstlist')   # "type13 firstlist"�� �ش��ϴ� ��带 ã�Ƴ��ϴ�. 
  A1_1st_node <- A1_nodes[1] %>% html_text()   # ù ��° ��忡�� text�� �����մϴ�.
  A1_1st_node <- gsub("\t","",A1_1st_node)   # text�� ��(\t)�� �����մϴ�.
  A1_1st_node <- gsub(" ","",A1_1st_node)   # text�� ������ �����մϴ�.
  A1_head_list <- strsplit(A1_1st_node, "\n")[[1]]   # text�� ����(\n)�� �߶���ϴ�. list�� ��ȯ�˴ϴ�. vector�� �ٲٱ� ���� [[1]]�� �ڿ� �ٿ��ݴϴ�.
  A1_head_list <- A1_head_list[-which(A1_head_list=="")]   # �������� �� character�� ������ �������� �����մϴ�.
  news_paper_top[i,'A1_Top'] <- A1_head_list[1]   # vector�� ù ��°�� �������� ����ֽ��ϴ�. �̸� �ռ� ������ ������ �����ӿ� �־��ݴϴ�.
}

write.csv(news_paper_top,"news_paper_1page_top.csv")   # csv ���Ϸ� �����մϴ�. ���丮 ������ ���ϸ� ���� ���� ���� ����˴ϴ�.


# advanced example ####################################
library(lubridate)

Date <- ymd("2017-04-12") - days(0:365)   # 2017-04-12�κ��� 1�� ������ ��¥�� ��� ��Ÿ���ϴ�.
df_2016 <- data.frame(Date)   # ������ ���������� ��ȯ�մϴ�.
df_2016_format <- format(df_2016$Date,"%Y%m%d")   #yyyy-mm-dd�� ������ url�� ������ �� �ֵ��� yyyymmdd�� ���·� �ٲ��ݴϴ�.

for (d in 1:length(df_2016_format)) {
  url_news <- paste0("http://news.naver.com/main/ranking/popularDay.nhn?mid=etc&sid1=111&date=",df_2016_format[d])   # �� ��ũ������ �� url�� �Է��մϴ�.
  news_data <- read_html(url_news)   # �Էµ� url���� html�� �о�ɴϴ�.
  
  section_name <- c("Policy","Economy","Society","Life","World","IT","TV_Ent","Sports")   # ī�װ��� ��Ī �ۼ�
  popular_new_head <- data.frame(head_1=c(1:8), head_2=NA, head_3=NA, head_4=NA, head_5=NA)   # ������ 5���� �� ī�װ��� ���� �Է��ϴ� ������ ������
  rownames(popular_new_head) <- section_name   # row name�� ī�װ��� ��Ī���� ���� (�����ϴ� csv���� ù ��° ���� ��Ÿ���ϴ�.)
  
  for(i in 1:(ncol(popular_new_head))){   # 1~5���� ��忡 ���� for���Դϴ�.
    find_num <- paste0('.num',i)   # ������ ���� ��ȣ�� �ٸ��Ƿ� ��ȣ�� �ٲ� �� �ֵ��� �մϴ�. 
    num_head <- html_nodes(news_data, find_num)   # i�� 1�� ���, num1�� �ش��ϴ� ��带 ã�Ƴ��ϴ�. 
    
    for(j in 1:nrow(popular_new_head)){   # ��ġ ~ ������������ ī�װ����� ���� for���Դϴ�.
      head_text <- gsub("\t","",num_head[j] %>% html_text())   # j ��° ��忡�� text�� ������ �Ŀ� ��(\t)�� �����մϴ�.
      head_text <- strsplit(head_text, "\r\n")[[1]]   # text�� "\r\n"���� �����ݴϴ�. list�� ��ȯ�˴ϴ�. vector�� �ٲٱ� ���� [[1]]�� �ڿ� �ٿ��ݴϴ�.
      if(i==1){
        popular_new_head[j,i] <- head_text[12]    # ù ���� ī�װ����� ��ġ�� ���� 12��°�� �������� ����ֽ��ϴ�. �̸� �ռ� ������ ������ �����ӿ� �־��ݴϴ�.
      }else{
        popular_new_head[j,i] <- head_text[5]   # ������ ī�װ������� 5��°�� �������� ����ֽ��ϴ�. �̸� �ռ� ������ ������ �����ӿ� �־��ݴϴ�.
      }
    }
  }
  write.csv(popular_new_head,paste0(df_2016_format[d],"_popular_news_head.csv"))   # ��¥���� csv ���Ϸ� �����մϴ�. ���丮 ������ ���ϸ� ���� ���� ���� ����˴ϴ�.
}
