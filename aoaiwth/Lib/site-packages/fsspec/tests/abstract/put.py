class AbstractPutTests:
    def test_put_file_to_existing_directory(
        self,
        fs,
        fs_join,
        fs_target,
        local_join,
        local_bulk_operations_scenario_0,
    ):
        # Copy scenario 1a
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)
        if not self.supports_empty_directories():
            # Force target directory to exist by adding a dummy file
            fs.touch(fs_join(target, "dummy"))
        assert fs.isdir(target)

        target_file2 = fs_join(target, "file2")
        target_subfile1 = fs_join(target, "subfile1")

        # Copy from source directory
        fs.put(local_join(source, "file2"), target)
        assert fs.isfile(target_file2)

        # Copy from sub directory
        fs.put(local_join(source, "subdir", "subfile1"), target)
        assert fs.isfile(target_subfile1)

        # Remove copied files
        fs.rm([target_file2, target_subfile1])
        assert not fs.exists(target_file2)
        assert not fs.exists(target_subfile1)

        # Repeat with trailing slash on target
        fs.put(local_join(source, "file2"), target + "/")
        assert fs.isdir(target)
        assert fs.isfile(target_file2)

        fs.put(local_join(source, "subdir", "subfile1"), target + "/")
        assert fs.isfile(target_subfile1)

    def test_put_file_to_new_directory(
        self, fs, fs_join, fs_target, local_join, local_bulk_operations_scenario_0
    ):
        # Copy scenario 1b
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)

        fs.put(
            local_join(source, "subdir", "subfile1"), fs_join(target, "newdir/")
        )  # Note trailing slash
        assert fs.isdir(target)
        assert fs.isdir(fs_join(target, "newdir"))
        assert fs.isfile(fs_join(target, "newdir", "subfile1"))

    def test_put_file_to_file_in_existing_directory(
        self, fs, fs_join, fs_target, local_join, local_bulk_operations_scenario_0
    ):
        # Copy scenario 1c
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)

        fs.put(local_join(source, "subdir", "subfile1"), fs_join(target, "newfile"))
        assert fs.isfile(fs_join(target, "newfile"))

    def test_put_file_to_file_in_new_directory(
        self, fs, fs_join, fs_target, local_join, local_bulk_operations_scenario_0
    ):
        # Copy scenario 1d
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)

        fs.put(
            local_join(source, "subdir", "subfile1"),
            fs_join(target, "newdir", "newfile"),
        )
        assert fs.isdir(fs_join(target, "newdir"))
        assert fs.isfile(fs_join(target, "newdir", "newfile"))

    def test_put_directory_to_existing_directory(
        self, fs, fs_join, fs_target, local_bulk_operations_scenario_0
    ):
        # Copy scenario 1e
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)
        if not self.supports_empty_directories():
            # Force target directory to exist by adding a dummy file
            dummy = fs_join(target, "dummy")
            fs.touch(dummy)
        assert fs.isdir(target)

        for source_slash, target_slash in zip([False, True], [False, True]):
            s = fs_join(source, "subdir")
            if source_slash:
                s += "/"
            t = target + "/" if target_slash else target

            # Without recursive does nothing
            fs.put(s, t)
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

            # With recursive
            fs.put(s, t, recursive=True)
            if source_slash:
                assert fs.isfile(fs_join(target, "subfile1"))
                assert fs.isfile(fs_join(target, "subfile2"))
                assert fs.isdir(fs_join(target, "nesteddir"))
                assert fs.isfile(fs_join(target, "nesteddir", "nestedfile"))
                assert not fs.exists(fs_join(target, "subdir"))

                fs.rm(fs.ls(target, detail=False), recursive=True)
            else:
                assert fs.isdir(fs_join(target, "subdir"))
                assert fs.isfile(fs_join(target, "subdir", "subfile1"))
                assert fs.isfile(fs_join(target, "subdir", "subfile2"))
                assert fs.isdir(fs_join(target, "subdir", "nesteddir"))
                assert fs.isfile(fs_join(target, "subdir", "nesteddir", "nestedfile"))

                fs.rm(fs_join(target, "subdir"), recursive=True)
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

            # Limit recursive by maxdepth
            fs.put(s, t, recursive=True, maxdepth=1)
            if source_slash:
                assert fs.isfile(fs_join(target, "subfile1"))
                assert fs.isfile(fs_join(target, "subfile2"))
                assert not fs.exists(fs_join(target, "nesteddir"))
                assert not fs.exists(fs_join(target, "subdir"))

                fs.rm(fs.ls(target, detail=False), recursive=True)
            else:
                assert fs.isdir(fs_join(target, "subdir"))
                assert fs.isfile(fs_join(target, "subdir", "subfile1"))
                assert fs.isfile(fs_join(target, "subdir", "subfile2"))
                assert not fs.exists(fs_join(target, "subdir", "nesteddir"))

                fs.rm(fs_join(target, "subdir"), recursive=True)
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

    def test_put_directory_to_new_directory(
        self, fs, fs_join, fs_target, local_bulk_operations_scenario_0
    ):
        # Copy scenario 1f
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)
        if not self.supports_empty_directories():
            # Force target directory to exist by adding a dummy file
            dummy = fs_join(target, "dummy")
            fs.touch(dummy)
        assert fs.isdir(target)

        for source_slash, target_slash in zip([False, True], [False, True]):
            s = fs_join(source, "subdir")
            if source_slash:
                s += "/"
            t = fs_join(target, "newdir")
            if target_slash:
                t += "/"

            # Without recursive does nothing
            fs.put(s, t)
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

            # With recursive
            fs.put(s, t, recursive=True)
            assert fs.isdir(fs_join(target, "newdir"))
            assert fs.isfile(fs_join(target, "newdir", "subfile1"))
            assert fs.isfile(fs_join(target, "newdir", "subfile2"))
            assert fs.isdir(fs_join(target, "newdir", "nesteddir"))
            assert fs.isfile(fs_join(target, "newdir", "nesteddir", "nestedfile"))
            assert not fs.exists(fs_join(target, "subdir"))

            fs.rm(fs_join(target, "newdir"), recursive=True)
            assert not fs.exists(fs_join(target, "newdir"))

            # Limit recursive by maxdepth
            fs.put(s, t, recursive=True, maxdepth=1)
            assert fs.isdir(fs_join(target, "newdir"))
            assert fs.isfile(fs_join(target, "newdir", "subfile1"))
            assert fs.isfile(fs_join(target, "newdir", "subfile2"))
            assert not fs.exists(fs_join(target, "newdir", "nesteddir"))
            assert not fs.exists(fs_join(target, "subdir"))

            fs.rm(fs_join(target, "newdir"), recursive=True)
            assert not fs.exists(fs_join(target, "newdir"))

    def test_put_glob_to_existing_directory(
        self, fs, fs_join, fs_target, local_join, local_bulk_operations_scenario_0
    ):
        # Copy scenario 1g
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)
        if not self.supports_empty_directories():
            # Force target directory to exist by adding a dummy file
            dummy = fs_join(target, "dummy")
            fs.touch(dummy)
        assert fs.isdir(target)

        for target_slash in [False, True]:
            t = target + "/" if target_slash else target

            # Without recursive
            fs.put(local_join(source, "subdir", "*"), t)
            assert fs.isfile(fs_join(target, "subfile1"))
            assert fs.isfile(fs_join(target, "subfile2"))
            assert not fs.isdir(fs_join(target, "nesteddir"))
            assert not fs.exists(fs_join(target, "nesteddir", "nestedfile"))
            assert not fs.exists(fs_join(target, "subdir"))

            fs.rm(fs.ls(target, detail=False), recursive=True)
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

            # With recursive
            fs.put(local_join(source, "subdir", "*"), t, recursive=True)
            assert fs.isfile(fs_join(target, "subfile1"))
            assert fs.isfile(fs_join(target, "subfile2"))
            assert fs.isdir(fs_join(target, "nesteddir"))
            assert fs.isfile(fs_join(target, "nesteddir", "nestedfile"))
            assert not fs.exists(fs_join(target, "subdir"))

            fs.rm(fs.ls(target, detail=False), recursive=True)
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

            # Limit recursive by maxdepth
            fs.put(local_join(source, "subdir", "*"), t, recursive=True, maxdepth=1)
            assert fs.isfile(fs_join(target, "subfile1"))
            assert fs.isfile(fs_join(target, "subfile2"))
            assert not fs.exists(fs_join(target, "nesteddir"))
            assert not fs.exists(fs_join(target, "subdir"))

            fs.rm(fs.ls(target, detail=False), recursive=True)
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

    def test_put_glob_to_new_directory(
        self, fs, fs_join, fs_target, local_join, local_bulk_operations_scenario_0
    ):
        # Copy scenario 1h
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)
        if not self.supports_empty_directories():
            # Force target directory to exist by adding a dummy file
            dummy = fs_join(target, "dummy")
            fs.touch(dummy)
        assert fs.isdir(target)

        for target_slash in [False, True]:
            t = fs_join(target, "newdir")
            if target_slash:
                t += "/"

            # Without recursive
            fs.put(local_join(source, "subdir", "*"), t)
            assert fs.isdir(fs_join(target, "newdir"))
            assert fs.isfile(fs_join(target, "newdir", "subfile1"))
            assert fs.isfile(fs_join(target, "newdir", "subfile2"))
            assert not fs.exists(fs_join(target, "newdir", "nesteddir"))
            assert not fs.exists(fs_join(target, "newdir", "nesteddir", "nestedfile"))
            assert not fs.exists(fs_join(target, "subdir"))
            assert not fs.exists(fs_join(target, "newdir", "subdir"))

            fs.rm(fs_join(target, "newdir"), recursive=True)
            assert not fs.exists(fs_join(target, "newdir"))

            # With recursive
            fs.put(local_join(source, "subdir", "*"), t, recursive=True)
            assert fs.isdir(fs_join(target, "newdir"))
            assert fs.isfile(fs_join(target, "newdir", "subfile1"))
            assert fs.isfile(fs_join(target, "newdir", "subfile2"))
            assert fs.isdir(fs_join(target, "newdir", "nesteddir"))
            assert fs.isfile(fs_join(target, "newdir", "nesteddir", "nestedfile"))
            assert not fs.exists(fs_join(target, "subdir"))
            assert not fs.exists(fs_join(target, "newdir", "subdir"))

            fs.rm(fs_join(target, "newdir"), recursive=True)
            assert not fs.exists(fs_join(target, "newdir"))

            # Limit recursive by maxdepth
            fs.put(local_join(source, "subdir", "*"), t, recursive=True, maxdepth=1)
            assert fs.isdir(fs_join(target, "newdir"))
            assert fs.isfile(fs_join(target, "newdir", "subfile1"))
            assert fs.isfile(fs_join(target, "newdir", "subfile2"))
            assert not fs.exists(fs_join(target, "newdir", "nesteddir"))
            assert not fs.exists(fs_join(target, "subdir"))
            assert not fs.exists(fs_join(target, "newdir", "subdir"))

            fs.rm(fs_join(target, "newdir"), recursive=True)
            assert not fs.exists(fs_join(target, "newdir"))

    def test_put_list_of_files_to_existing_directory(
        self,
        fs,
        fs_join,
        fs_target,
        local_join,
        local_bulk_operations_scenario_0,
        fs_path,
    ):
        # Copy scenario 2a
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)
        if not self.supports_empty_directories():
            # Force target directory to exist by adding a dummy file
            dummy = fs_join(target, "dummy")
            fs.touch(dummy)
        assert fs.isdir(target)

        source_files = [
            local_join(source, "file1"),
            local_join(source, "file2"),
            local_join(source, "subdir", "subfile1"),
        ]

        for target_slash in [False, True]:
            t = target + "/" if target_slash else target

            fs.put(source_files, t)
            assert fs.isfile(fs_join(target, "file1"))
            assert fs.isfile(fs_join(target, "file2"))
            assert fs.isfile(fs_join(target, "subfile1"))

            fs.rm(fs.find(target))
            assert fs.ls(target) == [] if self.supports_empty_directories() else [dummy]

    def test_put_list_of_files_to_new_directory(
        self, fs, fs_join, fs_target, local_join, local_bulk_operations_scenario_0
    ):
        # Copy scenario 2b
        source = local_bulk_operations_scenario_0

        target = fs_target
        fs.mkdir(target)

        source_files = [
            local_join(source, "file1"),
            local_join(source, "file2"),
            local_join(source, "subdir", "subfile1"),
        ]

        fs.put(source_files, fs_join(target, "newdir") + "/")  # Note trailing slash
        assert fs.isdir(fs_join(target, "newdir"))
        assert fs.isfile(fs_join(target, "newdir", "file1"))
        assert fs.isfile(fs_join(target, "newdir", "file2"))
        assert fs.isfile(fs_join(target, "newdir", "subfile1"))

    def test_put_directory_recursive(
        self, fs, fs_join, fs_target, local_fs, local_join, local_path
    ):
        # https://github.com/fsspec/filesystem_spec/issues/1062
        # Recursive cp/get/put of source directory into non-existent target directory.
        src = local_join(local_path, "src")
        src_file = local_join(src, "file")
        local_fs.mkdir(src)
        local_fs.touch(src_file)

        target = fs_target

        # put without slash
        assert not fs.exists(target)
        for loop in range(2):
            fs.put(src, target, recursive=True)
            assert fs.isdir(target)

            if loop == 0:
                assert fs.isfile(fs_join(target, "file"))
                assert not fs.exists(fs_join(target, "src"))
            else:
                assert fs.isfile(fs_join(target, "file"))
                assert fs.isdir(fs_join(target, "src"))
                assert fs.isfile(fs_join(target, "src", "file"))

        fs.rm(target, recursive=True)

        # put with slash
        assert not fs.exists(target)
        for loop in range(2):
            fs.put(src + "/", target, recursive=True)
            assert fs.isdir(target)
            assert fs.isfile(fs_join(target, "file"))
            assert not fs.exists(fs_join(target, "src"))
