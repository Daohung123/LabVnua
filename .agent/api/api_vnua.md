API Giảng Viên
1. API lấy thông tin của giảng viên
    - End Points = "/hrm/w-locgiangvieninfo";
    - PayLoad:[]
    - Response:
        {
        "is_hien_thi_group_hscn": false,
        "data": {
            "id_giang_vien": "",
            "ma_giang_vien": "",
            "ten_giang_vien": "",
            "is_danh_dau": false,
            "ngay_sinh": "",
            "email_1": "",
            "email_2": "",
            "dien_thoai_1": "",
            "dien_thoai_2": "",
            "hoc_ham": "",
            "hoc_vi": "",
            "khoa": "",
            "khoa_eg": "",
            "id_khoa": "",
            "bo_mon": "",
            "phan_loai": "",
            "phan_loai_eg": "",
            "trang_thai_lam_viec": "",
            "so_quyet_dinh_vao": "",
            "ngay_quyet_dinh_vao": "",
            "is_chon_ct_hoc": false,
            "doi_mat_khau": false,
            "id_form_danh_gia": "0",
            "id_ds_doi_tuong": "0",
            "is_tra_loi": false,
            "gioi_tinh": "",
            "que_quan": "",
            "dia_chi": "",
            "dan_toc": "",
            "ton_giao": "",
            "quoc_tich": "",
            "nam_vao_doan": "",
            "ngay_bat_dau_giang_day": "",
            "trinh_do_hoc_van": "",
            "danh_hieu_nha_giao": "",
            "bien_che": ""
        },
        "result": true,
        "code": 200
        }


2. API lấy chức năng của giảng viên
    - End Points = "/web/w-locdschucnang"
    - PayLoad:[]
    - Response:
        {
        "data": {
            "total_items": 0,
            "total_pages": 0,
            "release_time": "",
            "is_phan_cap_chuc_nang_mobile": false,
            "ds_chuc_nang": [
            {
                "id": "",
                "state": false,
                "ma_chuc_nang": "",
                "ma_menu": "",
                "thu_tu": 0,
                "ten_hien_thi": "",
                "ten_mobile": {
                "nhom": "",
                "ten_viet": "",
                "ten_eng": "",
                "ma_nhom_cha": ""
                },
                "ten_hien_thi_Eg": "",
                "ten_tooltip": "",
                "url": "",
                "url_danh_muc_hoc_lieu": "",
                "url_e_learning": "",
                "url_cong_dgrl": "",
                "ds_chi_tiet": []
            }
            ],
            "ds_chuc_nang_htld": []
        },
        "result": true,
        "code": 200
        }

3. API lấy danh sách thông báo
    - End Points = "web/w-locdsthongbao"
    - PayLoad:
        {
        "filter": {
            "id": null,
            "is_noi_dung": false,
            "is_web": false
        },
        "additional": {
            "paging": {
            "limit": 0,
            "page": 1
            },
            "ordering": [
            {
                "name": "",
                "order_type": 0
            }
            ]
        }
        }
    - Response: 
        {
        "data": {
            "total_items": 0,
            "total_pages": 0,
            "notification": 0,
            "ds_thong_bao": [
            {
                "id": "",
                "doi_tuong_search": "",
                "doi_tuong": 0,
                "phan_cap_search": "",
                "phan_cap_giang_vien": 0,
                "tieu_de": "",
                "noi_dung": "",
                "is_phai_xem": false,
                "ngay_gui": "",
                "nguoi_gui": "",
                "is_da_doc": false,
                "ds_doi_tuong": [],
                "phan_hoi": "",
                "is_xem_phan_hoi": false,
                "ngay_xem": ""
            }
            ]
        },
        "result": true,
        "code": 200
        } 


4. API lấy thời gian thời khóa biểu 
    - End Points = "sch/w-locdstkbtuanusertheohocky"
    - PayLoad: 
        {
        "filter": {
            "hoc_ky": 0,
            "ten_hoc_ky": ""
        },
        "additional": {
            "paging": {
            "limit": 0,
            "page": 1
            },
            "ordering": [
            {
                "name": null,
                "order_type": null
            }
            ]
        }
        }
    - Response: 
        {
        "data": {
            "total_items": 0,
            "total_pages": 0,
            "notification": 0,
            "ds_thong_bao": [
            {
                "id": "",
                "doi_tuong_search": "",
                "doi_tuong": 0,
                "phan_cap_search": "",
                "phan_cap_giang_vien": 0,
                "tieu_de": "",
                "noi_dung": "",
                "is_phai_xem": false,
                "ngay_gui": "",
                "nguoi_gui": "",
                "is_da_doc": false,
                "ds_doi_tuong": [],
                "phan_hoi": "",
                "is_xem_phan_hoi": false,
                "ngay_xem": ""
            }
            ]
        },
        "result": true,
        "code": 200
        }

5. API 