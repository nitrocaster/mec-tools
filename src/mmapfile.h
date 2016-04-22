/*
 * mmapfile.h: utility function for mmapping files
 */
#include <io.h>
#include <fcntl.h>
#include <sys/stat.h>
#include "mman.h"

static inline void *mmapfile(const char *pathname, int prot, int flags,
                             size_t *length)
{
	struct stat st;
	int openflags = (prot & PROT_WRITE) ? O_RDWR : O_RDONLY;
	int fd;
	void *p;

	fd = _open(pathname, openflags);
	if (fd == -1)
		return MAP_FAILED;

	if (fstat(fd, &st) == -1)
	{
		_close(fd);
		return MAP_FAILED;
	}

	*length = st.st_size;
	p = mmap(NULL, *length, prot, flags, fd, 0);

	_close(fd);
	return p;
}

