CREATE TABLE notice_images (
                               image_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                               notice_id BIGINT NOT NULL,
                               original_name VARCHAR(255) NOT NULL,
                               saved_file_name VARCHAR(255) NOT NULL,
                               reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               CONSTRAINT fk_notice_images_notice_id FOREIGN KEY (notice_id)
                                   REFERENCES notice_board (notice_id) ON DELETE CASCADE
);