<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$upload_dir = '../uploads/profile_images/';

if (!file_exists($upload_dir)) {
    mkdir($upload_dir, 0777, true);
}

if ($_FILES['image']) {
    $file = $_FILES['image'];
    $filename = time() . '_' . $file['name'];
    $filepath = $upload_dir . $filename;
    
    if (move_uploaded_file($file['tmp_name'], $filepath)) {
        $image_url = 'http://localhost/taskflow/uploads/profile_images/' . $filename;
        echo json_encode(['status' => 'success', 'image_url' => $image_url]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to upload file']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'No file uploaded']);
}
?> 